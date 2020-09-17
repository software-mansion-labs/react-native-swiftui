
#import <react/renderer/core/LayoutableShadowNode.h>
#import <react/renderer/core/RawProps.h>
#import <react/renderer/core/ComponentDescriptor.h>
#import <react/renderer/debug/SystraceSection.h>
#import <react/renderer/mounting/TelemetryController.h>
#import <react/renderer/mounting/MountingCoordinator.h>
#import <react/renderer/components/view/ViewProps.h>

#import <React/RCTAssert.h>
#import <React/RCTFollyConvert.h>
#import <React/RCTUtils.h>

#import <React/RCTConversions.h>
#import <React/RCTMountingTransactionObserverCoordinator.h>
#import <React/RCTComponentViewRegistry.h>

#import "RSUIMountingManager.h"
#import <ReactSwiftUI-Swift.h>

using namespace facebook::react;

@interface RSUIComponentViewFactory ()
+ (folly::dynamic)dynamicPropsValueForProps:(Props::Shared const &)props;
@end

@interface RSUIViewPropsObjC ()
- (void)updateDynamicProps:(folly::dynamic)dynamicProps;
@end

static void RCTPerformMountInstructions(
    ShadowViewMutationList const &mutations,
    RSUIViewRegistry *registry,
    RCTMountingTransactionObserverCoordinator &observerCoordinator,
    SurfaceId surfaceId)
{
  SystraceSection s("RCTPerformMountInstructions");

  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  for (auto const &mutation : mutations) {
    switch (mutation.type) {
      case ShadowViewMutation::Create: {
        auto &newChildShadowView = mutation.newChildShadowView;
//        auto &newChildViewDescriptor =
//            [registry dequeueComponentViewWithComponentHandle:newChildShadowView.componentHandle
//                                                          tag:newChildShadowView.tag];
//        observerCoordinator.registerViewComponentDescriptor(newChildViewDescriptor, surfaceId);

        RSUIViewDescriptor *viewDescriptor = [registry createViewWithTag:newChildShadowView.tag
                                                                    name:@(newChildShadowView.componentName)];

        folly::dynamic const &newProps = [RSUIComponentViewFactory dynamicPropsValueForProps:newChildShadowView.props];
        [viewDescriptor.props updateDynamicProps:newProps];

        auto const &layoutMetrics = newChildShadowView.layoutMetrics;

        [viewDescriptor updateLayoutMetricsWithX:layoutMetrics.frame.origin.x
                                               y:layoutMetrics.frame.origin.y
                                           width:layoutMetrics.frame.size.width
                                          height:layoutMetrics.frame.size.height];

        [viewDescriptor commitUpdates];
        break;
      }

      case ShadowViewMutation::Delete: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
//        auto &oldChildViewDescriptor = [registry componentViewDescriptorWithTag:oldChildShadowView.tag];

//        observerCoordinator.unregisterViewComponentDescriptor(oldChildViewDescriptor, surfaceId);

//        [registry enqueueComponentViewWithComponentHandle:oldChildShadowView.componentHandle
//                                                      tag:oldChildShadowView.tag
//                                  componentViewDescriptor:oldChildViewDescriptor];

        [registry deleteView:oldChildShadowView.tag];
        break;
      }

      case ShadowViewMutation::Insert: {
//        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &newChildShadowView = mutation.newChildShadowView;
        auto &parentShadowView = mutation.parentShadowView;
//        auto &newChildViewDescriptor = [registry componentViewDescriptorWithTag:newChildShadowView.tag];
//        auto &parentViewDescriptor = [registry componentViewDescriptorWithTag:parentShadowView.tag];

//        UIView<RCTComponentViewProtocol> *newChildComponentView = newChildViewDescriptor.view;
//
//        [newChildComponentView updateProps:newChildShadowView.props oldProps:oldChildShadowView.props];
//        [newChildComponentView updateEventEmitter:newChildShadowView.eventEmitter];
//        [newChildComponentView updateState:newChildShadowView.state oldState:oldChildShadowView.state];
//        [newChildComponentView updateLayoutMetrics:newChildShadowView.layoutMetrics
//                                  oldLayoutMetrics:oldChildShadowView.layoutMetrics];
//        [newChildComponentView finalizeUpdates:RNComponentViewUpdateMaskAll];
//
//        [parentViewDescriptor.view mountChildComponentView:newChildComponentView index:mutation.index];

        [registry insertViewWithTag:newChildShadowView.tag toParent:parentShadowView.tag atIndex:mutation.index];
        break;
      }

      case ShadowViewMutation::Remove: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &parentShadowView = mutation.parentShadowView;

//        auto &oldChildViewDescriptor = [registry componentViewDescriptorWithTag:oldChildShadowView.tag];
//        auto &parentViewDescriptor = [registry componentViewDescriptorWithTag:parentShadowView.tag];
//        [parentViewDescriptor.view unmountChildComponentView:oldChildViewDescriptor.view index:mutation.index];
        [registry removeView:oldChildShadowView.tag fromParent:parentShadowView.tag];
        break;
      }

      case ShadowViewMutation::Update: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &newChildShadowView = mutation.newChildShadowView;
        RSUIViewDescriptor *viewDescriptor = [registry viewDescriptorForTag:newChildShadowView.tag];

//        auto &newChildViewDescriptor = [registry componentViewDescriptorWithTag:newChildShadowView.tag];
//        UIView<RCTComponentViewProtocol> *newChildComponentView = newChildViewDescriptor.view;

        auto mask = RNComponentViewUpdateMask{};

        if (oldChildShadowView.props != newChildShadowView.props) {
          folly::dynamic const &newProps = [RSUIComponentViewFactory dynamicPropsValueForProps:newChildShadowView.props];
          [viewDescriptor.props updateDynamicProps:newProps];

//          [newChildComponentView updateProps:newChildShadowView.props oldProps:oldChildShadowView.props];
          mask |= RNComponentViewUpdateMaskProps;
        }

//        if (oldChildShadowView.eventEmitter != newChildShadowView.eventEmitter) {
//          [newChildComponentView updateEventEmitter:newChildShadowView.eventEmitter];
//          mask |= RNComponentViewUpdateMaskEventEmitter;
//        }
//
//        if (oldChildShadowView.state != newChildShadowView.state) {
//          [newChildComponentView updateState:newChildShadowView.state oldState:oldChildShadowView.state];
//          mask |= RNComponentViewUpdateMaskState;
//        }

        if (oldChildShadowView.layoutMetrics != newChildShadowView.layoutMetrics) {
          auto const &layoutMetrics = newChildShadowView.layoutMetrics;

          [viewDescriptor updateLayoutMetricsWithX:layoutMetrics.frame.origin.x
                                                 y:layoutMetrics.frame.origin.y
                                             width:layoutMetrics.frame.size.width
                                            height:layoutMetrics.frame.size.height];

//          [newChildComponentView updateLayoutMetrics:newChildShadowView.layoutMetrics
//                                    oldLayoutMetrics:oldChildShadowView.layoutMetrics];
          mask |= RNComponentViewUpdateMaskLayoutMetrics;
        }

        if (mask != RNComponentViewUpdateMaskNone) {
          [viewDescriptor commitUpdates];
//          [newChildComponentView finalizeUpdates:mask];
        }
        break;
      }
    }
  }
  [CATransaction commit];
}

@implementation RSUIMountingManager {
  RCTMountingTransactionObserverCoordinator _observerCoordinator;
  BOOL _transactionInFlight;
  BOOL _followUpTransactionRequired;

  RSUIComponentViewFactory *_componentViewFactory;
  RSUIViewRegistry *_viewRegistry;
}

- (instancetype)init
{
  if (self = [super init]) {
    _componentViewFactory = [RSUIComponentViewFactory standardComponentViewFactory];
    _viewRegistry = [RSUIViewRegistry new];
  }
  return self;
}

- (RSUIComponentViewFactory *)componentViewFactory
{
  return _componentViewFactory;
}

- (RSUIViewRegistry *)viewRegistry
{
  return _viewRegistry;
}

- (void)scheduleTransaction:(MountingCoordinator::Shared const &)mountingCoordinator
{
  if (RCTIsMainQueue()) {
    // Already on the proper thread, so:
    // * No need to do a thread jump;
    // * No need to do expensive copy of all mutations;
    // * No need to allocate a block.
    [self initiateTransaction:mountingCoordinator];
    return;
  }

  auto mountingCoordinatorCopy = mountingCoordinator;
  RCTExecuteOnMainQueue(^{
    RCTAssertMainQueue();
    [self initiateTransaction:mountingCoordinatorCopy];
  });
}

- (void)dispatchCommand:(ReactTag)reactTag commandName:(NSString *)commandName args:(NSArray *)args
{
  if (RCTIsMainQueue()) {
    // Already on the proper thread, so:
    // * No need to do a thread jump;
    // * No need to allocate a block.
    [self synchronouslyDispatchCommandOnUIThread:reactTag commandName:commandName args:args];
    return;
  }

  RCTExecuteOnMainQueue(^{
    RCTAssertMainQueue();
    [self synchronouslyDispatchCommandOnUIThread:reactTag commandName:commandName args:args];
  });
}

- (void)initiateTransaction:(MountingCoordinator::Shared const &)mountingCoordinator
{
  SystraceSection s("-[RCTMountingManager initiateTransaction:]");
  RCTAssertMainQueue();

  if (_transactionInFlight) {
    _followUpTransactionRequired = YES;
    return;
  }

  do {
    _followUpTransactionRequired = NO;
    _transactionInFlight = YES;
    [self performTransaction:mountingCoordinator];
    _transactionInFlight = NO;
  } while (_followUpTransactionRequired);
}

- (void)performTransaction:(MountingCoordinator::Shared const &)mountingCoordinator
{
  SystraceSection s("-[RCTMountingManager performTransaction:]");
  RCTAssertMainQueue();

  auto surfaceId = mountingCoordinator->getSurfaceId();

  mountingCoordinator->getTelemetryController().pullTransaction(
      [&](MountingTransactionMetadata metadata) {
        [self.delegate mountingManager:self willMountComponentsWithRootTag:surfaceId];
        _observerCoordinator.notifyObserversMountingTransactionWillMount(metadata);
      },
      [&](ShadowViewMutationList const &mutations) {
        RCTPerformMountInstructions(mutations, _viewRegistry, _observerCoordinator, surfaceId);
      },
      [&](MountingTransactionMetadata metadata) {
        _observerCoordinator.notifyObserversMountingTransactionDidMount(metadata);
        [self.delegate mountingManager:self didMountComponentsWithRootTag:surfaceId];
      });
}

- (void)synchronouslyUpdateViewOnUIThread:(ReactTag)reactTag
                             changedProps:(NSDictionary *)props
                      componentDescriptor:(const ComponentDescriptor &)componentDescriptor
{
//  RCTAssertMainQueue();
//  UIView<RCTComponentViewProtocol> *componentView = [_componentViewRegistry findComponentViewWithTag:reactTag];
//  SharedProps oldProps = [componentView props];
//  SharedProps newProps = componentDescriptor.cloneProps(oldProps, RawProps(convertIdToFollyDynamic(props)));
//  [componentView updateProps:newProps oldProps:oldProps];
}

- (void)synchronouslyDispatchCommandOnUIThread:(ReactTag)reactTag
                                   commandName:(NSString *)commandName
                                          args:(NSArray *)args
{
//  RCTAssertMainQueue();
//  UIView<RCTComponentViewProtocol> *componentView = [_componentViewRegistry findComponentViewWithTag:reactTag];
//  [componentView handleCommand:commandName args:args];
}

@end
