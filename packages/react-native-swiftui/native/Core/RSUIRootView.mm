
#if !TARGET_OS_OSX
#import <cxxreact/MessageQueueThread.h>

#import <react/utils/ContextContainer.h>
#import <react/utils/ManagedObjectWrapper.h>
#import <react/config/ReactNativeConfig.h>

#import <React/RCTBridge+Private.h>
#import <React/RCTImageLoader.h>
#import <React/RCTImageLoaderWithAttributionProtocol.h>
#import <React-runtimeexecutor/ReactCommon/RuntimeExecutor.h>

#import "RSUIRootView.h"
#import "RSUISurface.h"
#import "RSUISurfacePresenter.h"

using namespace facebook::react;

@interface RCTSurfaceHostingView () {
  // This is a hacky way to have an access to ivar variables from within RCTSurfaceHostingView.
  @protected
  RCTSurfaceStage _stage;
  id<RCTSurfaceProtocol> _surface;
  RCTSurfaceSizeMeasureMode _sizeMeasureMode;
}
- (void)setStage:(RCTSurfaceStage)stage;
- (void)_updateViews;
- (void)_invalidateLayout;
@end

@implementation RSUIRootView

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties
{
  if (self = [super initWithFrame:CGRectZero]) {
    _appContext = [[RSUIAppContext alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
    _surface = _appContext.surface;

    [_surface start];

    _sizeMeasureMode = RCTSurfaceSizeMeasureModeWidthExact | RCTSurfaceSizeMeasureModeHeightExact;
    _surface.delegate = self;
    _stage = _surface.stage;

    [self _updateViews];

    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)didMoveToWindow
{
  [super didMoveToWindow];
  [self _updateViews];
}

- (RSUIViewRegistryObjC *)viewRegistry
{
  return _appContext.viewRegistry;
}

#pragma mark - RCTSurfaceDelegate

- (void)surface:(__unused RCTSurface *)surface didChangeStage:(RCTSurfaceStage)stage
{
  RCTExecuteOnMainQueue(^{
    [self setStage:stage];
  });
}

- (void)surface:(__unused RCTSurface *)surface didChangeIntrinsicSize:(__unused CGSize)intrinsicSize
{
  RCTExecuteOnMainQueue(^{
    [self _invalidateLayout];
  });
}

@end
#endif
