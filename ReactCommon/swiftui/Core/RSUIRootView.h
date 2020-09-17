
#import <React/RCTSurfaceHostingView.h>

@interface RSUIRootView : RCTSurfaceHostingView <RCTSurfaceDelegate>

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties;

@end
