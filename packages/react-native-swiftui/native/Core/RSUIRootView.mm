
#import <cxxreact/MessageQueueThread.h>

#import <react/utils/ContextContainer.h>
#import <react/utils/ManagedObjectWrapper.h>
#import <react/config/ReactNativeConfig.h>

#import <React/RCTBridge+Private.h>
#import <React/RCTImageLoader.h>
#import <React/RCTImageLoaderWithAttributionProtocol.h>

#import "RSUIRootView.h"
#import "RSUISurface.h"
#import "RSUISurfacePresenter.h"

using namespace facebook::react;

// Copied from RCTSurfacePresenterBridgeAdapter.mm
@interface RCTBridge ()
- (std::shared_ptr<MessageQueueThread>)jsMessageThread;
- (void)invokeAsync:(std::function<void()> &&)func;
@end

// Copied from RCTSurfacePresenterBridgeAdapter.mm
static ContextContainer::Shared RCTContextContainerFromBridge(RCTBridge *bridge)
{
  auto contextContainer = std::make_shared<ContextContainer const>();

  RCTImageLoader *imageLoader = RCTTurboModuleEnabled()
      ? [bridge moduleForName:@"RCTImageLoader" lazilyLoadIfNecessary:YES]
      : [bridge moduleForClass:[RCTImageLoader class]];

  contextContainer->insert("Bridge", wrapManagedObjectWeakly(bridge));
  contextContainer->insert("RCTImageLoader", wrapManagedObject((id<RCTImageLoaderWithAttributionProtocol>)imageLoader));
  return contextContainer;
}

// Copied from RCTSurfacePresenterBridgeAdapter.mm
static RuntimeExecutor RCTRuntimeExecutorFromBridge(RCTBridge *bridge)
{
  RCTAssert(bridge, @"RCTRuntimeExecutorFromBridge: Bridge must not be nil.");

  auto bridgeWeakWrapper = wrapManagedObjectWeakly([bridge batchedBridge] ?: bridge);

  RuntimeExecutor runtimeExecutor = [bridgeWeakWrapper](
                                        std::function<void(facebook::jsi::Runtime & runtime)> &&callback) {
    RCTBridge *bridge = unwrapManagedObjectWeakly(bridgeWeakWrapper);

    RCTAssert(bridge, @"RCTRuntimeExecutorFromBridge: Bridge must not be nil at the moment of scheduling a call.");

    [bridge invokeAsync:[bridgeWeakWrapper, callback = std::move(callback)]() {
      RCTCxxBridge *batchedBridge = (RCTCxxBridge *)unwrapManagedObjectWeakly(bridgeWeakWrapper);

      RCTAssert(batchedBridge, @"RCTRuntimeExecutorFromBridge: Bridge must not be nil at the moment of invocation.");

      if (!batchedBridge) {
        return;
      }

      auto runtime = (facebook::jsi::Runtime *)(batchedBridge.runtime);

      RCTAssert(
          runtime, @"RCTRuntimeExecutorFromBridge: Bridge must have a valid jsi::Runtime at the moment of invocation.");

      if (!runtime) {
        return;
      }

      callback(*runtime);
    }];
  };

  return runtimeExecutor;
}

@interface RCTSurfaceHostingView () {
  // This is a hacky way to have an access to ivar variables from within RCTSurfaceHostingView.
  @protected
  id<RCTSurfaceProtocol> _surface;
  RCTSurfaceSizeMeasureMode _sizeMeasureMode;
}
- (void)_updateViews;
@end

@implementation RSUIRootView {
  std::shared_ptr<const ReactNativeConfig> _reactNativeConfig;
  ContextContainer::Shared _contextContainer;

  RSUISurfacePresenter *_surfacePresenter;
  RCTSurfaceStage _stage;

  __weak RCTBridge *_bridge;
  __weak RCTBridge *_batchedBridge;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties
{
  if (self = [super initWithFrame:CGRectZero]) {
    _contextContainer = std::make_shared<ContextContainer const>();
    _reactNativeConfig = std::make_shared<EmptyReactNativeConfig const>();
    _bridge = bridge;
    _batchedBridge = [_bridge batchedBridge] ?: _bridge;

    _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
    _contextContainer->update(*RCTContextContainerFromBridge(_bridge));

    _surfacePresenter = [[RSUISurfacePresenter alloc] initWithContextContainer:_contextContainer
                                                               runtimeExecutor:RCTRuntimeExecutorFromBridge(_bridge)];
    _surface = [[RSUISurface alloc] initWithSurfacePresenter:_surfacePresenter
                                                  moduleName:moduleName
                                           initialProperties:initialProperties];

    _bridge.surfacePresenter = _surfacePresenter;

    [self _updateSurfacePresenter];
    [self _addBridgeObservers:_bridge];

    [_surface start];

    _sizeMeasureMode = RCTSurfaceSizeMeasureModeWidthExact | RCTSurfaceSizeMeasureModeHeightExact;

    _surface.delegate = self;
    _stage = _surface.stage;
    [self _updateViews];

    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)dealloc
{
  [_surfacePresenter suspend];
  [_surface stop];
}

- (RSUIViewRegistryObjC *)viewRegistry
{
  return _surfacePresenter.viewRegistry;
}

#pragma mark - Stuff copied from RCTSurfacePresenterBridgeAdapter.mm

- (void)_updateSurfacePresenter
{
  _surfacePresenter.runtimeExecutor = RCTRuntimeExecutorFromBridge(_bridge);
  _surfacePresenter.contextContainer->update(*RCTContextContainerFromBridge(_bridge));

  [_bridge setSurfacePresenter:_surfacePresenter];
  [_batchedBridge setSurfacePresenter:_surfacePresenter];
}

- (void)_addBridgeObservers:(RCTBridge *)bridge
{
  if (!bridge) {
    return;
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleBridgeWillReloadNotification:)
                                               name:RCTBridgeWillReloadNotification
                                             object:bridge];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleJavaScriptDidLoadNotification:)
                                               name:RCTJavaScriptDidLoadNotification
                                             object:bridge];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleBridgeWillBeInvalidatedNotification:)
                                               name:RCTBridgeWillBeInvalidatedNotification
                                             object:bridge];
}

- (void)_removeBridgeObservers:(RCTBridge *)bridge
{
  if (!bridge) {
    return;
  }

  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCTBridgeWillReloadNotification object:bridge];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCTJavaScriptDidLoadNotification object:bridge];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCTBridgeWillBeInvalidatedNotification object:bridge];
}

#pragma mark - Bridge events

- (void)handleBridgeWillReloadNotification:(NSNotification *)notification
{
  [_surfacePresenter suspend];
}

- (void)handleBridgeWillBeInvalidatedNotification:(NSNotification *)notification
{
  [_surfacePresenter suspend];
}

- (void)handleJavaScriptDidLoadNotification:(NSNotification *)notification
{
  RCTBridge *bridge = notification.userInfo[@"bridge"];
  if (bridge == _batchedBridge) {
    // Nothing really changed.
    return;
  }

  _batchedBridge = bridge;
  _batchedBridge.surfacePresenter = _surfacePresenter;

  [self _updateSurfacePresenter];

  [_surfacePresenter resume];
}

@end
