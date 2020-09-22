
#import <better/mutex.h>

//#import <React/RCTFollyConvert.h>
//
//#import <react/renderer/mounting/ShadowView.h>
//#import <react/renderer/mounting/MountingCoordinator.h>
#import <react/renderer/components/root/RootShadowNode.h>
#import <react/utils/ManagedObjectWrapper.h>
#import <react/utils/RunLoopObserver.h>
#import <react/renderer/scheduler/SchedulerToolbox.h>
#import <react/config/ReactNativeConfig.h>
#import <react/renderer/scheduler/SynchronousEventBeat.h>
#import <react/renderer/scheduler/AsynchronousEventBeat.h>
#import <React/MainRunLoopEventBeat.h>

#import <React/PlatformRunLoopObserver.h>
#import <React/RCTComponentViewRegistry.h>
#import <React/RCTUtils.h>
#import <React/RCTSurfaceStage.h>
#import <React/RCTMountingManager.h>
#import <React/RuntimeEventBeat.h>
#import <React/RCTUtils.h>
#import <React/RCTI18nUtil.h>
#import <React/RCTSurfaceRootView.h>
#import <React/RCTSurfaceView+Internal.h>
#import <React/RCTFollyConvert.h>

#import "RSUISurface.h"
#import "RSUISurfaceView.h"
#import "RSUISurfacePresenter.h"
#import "RSUISurfaceRegistry.h"
#import "RSUIMountingManager.h"

#import <ReactSwiftUI-Swift.h>

using namespace facebook;
using namespace facebook::react;

static inline LayoutConstraints RCTGetLayoutConstraintsForSize(CGSize minimumSize, CGSize maximumSize)
{
  return {
    .minimumSize = {minimumSize.width, minimumSize.height},
    .maximumSize = {maximumSize.width, maximumSize.height},
    .layoutDirection = [[RCTI18nUtil sharedInstance] isRTL] ? LayoutDirection::RightToLeft : LayoutDirection::LeftToRight,
  };
}

static inline LayoutContext RCTGetLayoutContext(CGPoint viewportOffset)
{
  return {
    .pointScaleFactor = RCTScreenScale(),
    .swapLeftAndRightInRTL = [[RCTI18nUtil sharedInstance] isRTL] && [[RCTI18nUtil sharedInstance] doLeftAndRightSwapInRTL],
    .fontSizeMultiplier = RCTFontSizeMultiplier(),
    .viewportOffset = {viewportOffset.x, viewportOffset.y}
  };
}

@interface RSUIMountingManager ()
- (void)scheduleTransaction:(MountingCoordinator::Shared const &)mountingCoordinator;
- (void)synchronouslyUpdateViewOnUIThread:(ReactTag)reactTag
                             changedProps:(NSDictionary *)props
                      componentDescriptor:(const ComponentDescriptor &)componentDescriptor;
@end

@interface RSUIComponentViewFactory ()
- (ComponentDescriptorRegistry::Shared)createComponentDescriptorRegistryWithParameters:(ComponentDescriptorParameters)parameters;
@end

@implementation RSUISurfacePresenter {
  // Protected by `_schedulerLifeCycleMutex`.
  std::mutex _schedulerLifeCycleMutex;
  ContextContainer::Shared _contextContainer;
  RuntimeExecutor _runtimeExecutor;

  // Protected by `_schedulerAccessMutex`.
  std::mutex _schedulerAccessMutex;
  RCTScheduler *_Nullable _scheduler;

  // Protected by `_observerListMutex`.
  better::shared_mutex _observerListMutex;
  NSMutableArray<id<RCTSurfacePresenterObserver>> *_observers;

  RSUIMountingManager *_mountingManager; // Thread-safe.
  RSUISurfaceRegistry *_surfaceRegistry; // Thread-safe.
}

- (instancetype)initWithContextContainer:(ContextContainer::Shared)contextContainer
                         runtimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  if (self = [super init]) {
    _contextContainer = contextContainer;
    _runtimeExecutor = runtimeExecutor;

    _surfaceRegistry = [RSUISurfaceRegistry new];
    _mountingManager = [RSUIMountingManager new];
    _mountingManager.delegate = self;

    _observers = [NSMutableArray array];

    _scheduler = [self createScheduler];
  }
  return self;
}

- (RSUIViewRegistry *)viewRegistry
{
  return _mountingManager.viewRegistry;
}

#pragma mark - Mutex-protected members

- (nullable RCTScheduler *)_scheduler
{
  std::lock_guard<std::mutex> lock(_schedulerAccessMutex);
  return _scheduler;
}

- (ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  return _contextContainer;
}

- (void)setContextContainer:(ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  _contextContainer = contextContainer;
}

- (RuntimeExecutor)runtimeExecutor
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  return _runtimeExecutor;
}

- (void)setRuntimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  _runtimeExecutor = runtimeExecutor;
}

#pragma mark - Internal Surface-dedicated Interface

- (void)registerSurface:(RSUISurface *)surface
{
  RCTScheduler *scheduler = [self _scheduler];
  [_surfaceRegistry registerSurface:surface];
  if (scheduler) {
    [self startSurface:surface scheduler:scheduler];
  }
}

- (void)unregisterSurface:(RSUISurface *)surface
{
  RCTScheduler *scheduler = [self _scheduler];
  if (scheduler) {
    [self stopSurface:surface scheduler:scheduler];
  }
  [_surfaceRegistry unregisterSurface:surface];
}

- (void)setProps:(NSDictionary *)props surface:(RSUISurface *)surface
{
  RCTScheduler *scheduler = [self _scheduler];
  if (scheduler) {
    [self stopSurface:surface scheduler:scheduler];
    [self startSurface:surface scheduler:scheduler];
  }
}

- (RSUISurface *)surfaceForRootTag:(ReactTag)rootTag
{
  return [_surfaceRegistry surfaceForRootTag:rootTag];
}

- (CGSize)sizeThatFitsMinimumSize:(CGSize)minimumSize
                      maximumSize:(CGSize)maximumSize
                          surface:(RSUISurface *)surface
{
  RCTScheduler *scheduler = [self _scheduler];
  if (!scheduler) {
    return minimumSize;
  }
  LayoutContext layoutContext = RCTGetLayoutContext(surface.viewportOffset);
  LayoutConstraints layoutConstraints = RCTGetLayoutConstraintsForSize(minimumSize, maximumSize);
  return [scheduler measureSurfaceWithLayoutConstraints:layoutConstraints
                                          layoutContext:layoutContext
                                              surfaceId:surface.rootTag];
  return CGSizeZero;
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize surface:(RSUISurface *)surface
{
  RCTScheduler *scheduler = [self _scheduler];
  if (!scheduler) {
    return;
  }
  LayoutContext layoutContext = RCTGetLayoutContext(surface.viewportOffset);
  LayoutConstraints layoutConstraints = RCTGetLayoutConstraintsForSize(minimumSize, maximumSize);
  [scheduler constraintSurfaceLayoutWithLayoutConstraints:layoutConstraints
                                            layoutContext:layoutContext
                                                surfaceId:surface.rootTag];
}

- (UIView *)findComponentViewWithTag_DO_NOT_USE_DEPRECATED:(NSInteger)tag
{
//  UIView<RCTComponentViewProtocol> *componentView =
//      [_mountingManager.componentViewRegistry findComponentViewWithTag:tag];
//  return componentView;
  return nil;
}

- (BOOL)synchronouslyUpdateViewOnUIThread:(NSNumber *)reactTag props:(NSDictionary *)props
{
//  RCTScheduler *scheduler = [self _scheduler];
//  if (!scheduler) {
//    return NO;
//  }

//  ReactTag tag = [reactTag integerValue];
//  UIView<RCTComponentViewProtocol> *componentView =
//      [_mountingManager.componentViewRegistry findComponentViewWithTag:tag];
//  if (componentView == nil) {
//    return NO; // This view probably isn't managed by Fabric
//  }
//  ComponentHandle handle = [[componentView class] componentDescriptorProvider].handle;
//  auto *componentDescriptor = [scheduler findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN:handle];

//  if (!componentDescriptor) {
//    return YES;
//  }

//  [_mountingManager synchronouslyUpdateViewOnUIThread:tag changedProps:props componentDescriptor:*componentDescriptor];
  return NO;
}

- (BOOL)synchronouslyWaitSurface:(RSUISurface *)surface timeout:(NSTimeInterval)timeout
{
  RCTScheduler *scheduler = [self _scheduler];
  if (!scheduler) {
    return NO;
  }

  auto mountingCoordinator = [scheduler mountingCoordinatorWithSurfaceId:surface.rootTag];

  if (!mountingCoordinator->waitForTransaction(std::chrono::duration<NSTimeInterval>(timeout))) {
    return NO;
  }

  [_mountingManager scheduleTransaction:mountingCoordinator];

  return YES;
}

- (BOOL)suspend
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);

  RCTScheduler *scheduler;
  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);

    if (!_scheduler) {
      return NO;
    }
    scheduler = _scheduler;
    _scheduler = nil;
  }

  [self stopAllSurfacesWithScheduler:scheduler];

  return YES;
}

- (BOOL)resume
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);

  RCTScheduler *scheduler;
  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);

    if (_scheduler) {
      return NO;
    }
    scheduler = [self createScheduler];
  }

  [self startAllSurfacesWithScheduler:scheduler];

  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);
    _scheduler = scheduler;
  }

  return YES;
}

#pragma mark - Observers

- (void)addObserver:(nonnull id<RCTSurfacePresenterObserver>)observer
{
  std::unique_lock<better::shared_mutex> lock(_observerListMutex);
  [_observers addObject:observer];
}

- (void)removeObserver:(nonnull id<RCTSurfacePresenterObserver>)observer
{
  std::unique_lock<better::shared_mutex> lock(_observerListMutex);
  [_observers removeObject: observer];
}

#pragma mark - RCTSchedulerDelegate

- (void)schedulerDidFinishTransaction:(const facebook::react::MountingCoordinator::Shared &)mountingCoordinator
{
  RSUISurface *surface = [_surfaceRegistry surfaceForRootTag:mountingCoordinator->getSurfaceId()];
  [surface setStage:RCTSurfaceStagePrepared];
  [_mountingManager scheduleTransaction:mountingCoordinator];
}

- (void)schedulerDidDispatchCommand:(const facebook::react::ShadowView &)shadowView
                        commandName:(const std::string &)commandName args:(const folly::dynamic)args
{
  ReactTag tag = shadowView.tag;
  NSString *commandStr = [[NSString alloc] initWithUTF8String:commandName.c_str()];
  NSArray *argsArray = convertFollyDynamicToId(args);

  [self->_mountingManager dispatchCommand:tag commandName:commandStr args:argsArray];
}

#pragma mark - RSUIMountingManagerDelegate

- (void)mountingManager:(RSUIMountingManager *)mountingManager willMountComponentsWithRootTag:(ReactTag)rootTag
{
  RCTAssertMainQueue();

  std::shared_lock<better::shared_mutex> lock(_observerListMutex);
  for (id<RCTSurfacePresenterObserver> observer in _observers) {
    if ([observer respondsToSelector:@selector(willMountComponentsWithRootTag:)]) {
      [observer willMountComponentsWithRootTag:rootTag];
    }
  }
}

- (void)mountingManager:(RSUIMountingManager *)mountingManager didMountComponentsWithRootTag:(ReactTag)rootTag
{
  RCTAssertMainQueue();

  RSUISurface *surface = [_surfaceRegistry surfaceForRootTag:rootTag];
  RCTSurfaceStage stage = surface.stage;
  if (stage & RCTSurfaceStagePrepared) {
    // We have to progress the stage only if the preparing phase is done.
    if ([surface setStage:RCTSurfaceStageMounted]) {
//      auto rootComponentViewDescriptor =
//          [_mountingManager.componentViewRegistry componentViewDescriptorWithTag:rootTag];
//      surface.view.rootView = (RCTSurfaceRootView *)rootComponentViewDescriptor.view;
      [surface.view mountContentView];
    }
  }

  std::shared_lock<better::shared_mutex> lock(_observerListMutex);
  for (id<RCTSurfacePresenterObserver> observer in _observers) {
    if ([observer respondsToSelector:@selector(didMountComponentsWithRootTag:)]) {
      [observer didMountComponentsWithRootTag:rootTag];
    }
  }
}

#pragma mark - Private

- (nonnull RCTScheduler *)createScheduler
{
  auto reactNativeConfig = _contextContainer->at<std::shared_ptr<ReactNativeConfig const>>("ReactNativeConfig");
  auto componentRegistryFactory = [factory = wrapManagedObject(_mountingManager.componentViewFactory)](EventDispatcher::Weak const &eventDispatcher, ContextContainer::Shared const &contextContainer) {
    return [(RSUIComponentViewFactory *)unwrapManagedObject(factory) createComponentDescriptorRegistryWithParameters:{eventDispatcher, contextContainer}];
  };

  auto runtimeExecutor = _runtimeExecutor;
  auto toolbox = SchedulerToolbox{};
  toolbox.contextContainer = _contextContainer;
  toolbox.componentRegistryFactory = componentRegistryFactory;
  toolbox.runtimeExecutor = _runtimeExecutor;
  toolbox.mainRunLoopObserverFactory = [](RunLoopObserver::Activity activities,
                                          RunLoopObserver::WeakOwner const &owner) {
    return std::make_unique<MainRunLoopObserver>(activities, owner);
  };

  if (reactNativeConfig && reactNativeConfig->getBool("react_fabric:enable_run_loop_based_event_beat_ios")) {
    toolbox.synchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
      auto runLoopObserver =
          std::make_unique<MainRunLoopObserver const>(RunLoopObserver::Activity::BeforeWaiting, ownerBox->owner);
      return std::make_unique<SynchronousEventBeat>(std::move(runLoopObserver), runtimeExecutor);
    };

    toolbox.asynchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
      auto runLoopObserver =
          std::make_unique<MainRunLoopObserver const>(RunLoopObserver::Activity::BeforeWaiting, ownerBox->owner);
      return std::make_unique<AsynchronousEventBeat>(std::move(runLoopObserver), runtimeExecutor);
    };
  } else {
    toolbox.synchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
      return std::make_unique<MainRunLoopEventBeat>(ownerBox, runtimeExecutor);
    };

    toolbox.asynchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
      return std::make_unique<RuntimeEventBeat>(ownerBox, runtimeExecutor);
    };
  }

  RCTScheduler *scheduler = [[RCTScheduler alloc] initWithToolbox:toolbox];
  scheduler.delegate = self;

  return scheduler;
}

- (void)startSurface:(RSUISurface *)surface scheduler:(RCTScheduler *)scheduler
{
  RSUIMountingManager *mountingManager = _mountingManager;
  RCTExecuteOnMainQueue(^{
    [mountingManager.viewRegistry create:surface.rootTag name:@"RootView"];
  });

  LayoutContext layoutContext = RCTGetLayoutContext(surface.viewportOffset);

  LayoutConstraints layoutConstraints = RCTGetLayoutConstraintsForSize(surface.minimumSize, surface.maximumSize);

  [scheduler startSurfaceWithSurfaceId:surface.rootTag
                            moduleName:surface.moduleName
                          initialProps:surface.properties
                     layoutConstraints:layoutConstraints
                         layoutContext:layoutContext];
}

- (void)stopSurface:(RSUISurface *)surface scheduler:(RCTScheduler *)scheduler
{
  [scheduler stopSurfaceWithSurfaceId:surface.rootTag];

//  RSUIMountingManager *mountingManager = _mountingManager;
//  RCTExecuteOnMainQueue(^{
//    surface.view.rootView = nil;
//    RCTComponentViewDescriptor rootViewDescriptor =
//        [mountingManager.componentViewRegistry componentViewDescriptorWithTag:surface.rootTag];
//    [mountingManager.componentViewRegistry enqueueComponentViewWithComponentHandle:RootShadowNode::Handle()
//                                                                               tag:surface.rootTag
//                                                           componentViewDescriptor:rootViewDescriptor];
//  });

  [surface unsetStage:(RCTSurfaceStagePrepared | RCTSurfaceStageMounted)];
}

- (void)startAllSurfacesWithScheduler:(RCTScheduler *)scheduler
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<RSUISurface *> *enumerator) {
    for (RSUISurface *surface in enumerator) {
      [self startSurface:surface scheduler:scheduler];
    }
  }];
}

- (void)stopAllSurfacesWithScheduler:(RCTScheduler *)scheduler
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<RSUISurface *> *enumerator) {
    for (RSUISurface *surface in enumerator) {
      [self stopSurface:surface scheduler:scheduler];
    }
  }];
}

@end
