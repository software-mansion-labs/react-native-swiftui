
#import <React/RCTSurfaceView.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSUISurfaceView : RCTSurfaceView

- (instancetype)initWithSurface:(RCTSurface *)surface viewRegistry:(id)viewRegistry;

- (void)mountContentView;

@end

NS_ASSUME_NONNULL_END
