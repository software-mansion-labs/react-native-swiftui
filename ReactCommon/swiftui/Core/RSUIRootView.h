
#import <React/RCTSurfaceHostingView.h>

#import "RSUIViewRegistryObjC.h"

@interface RSUIRootView : RCTSurfaceHostingView <RCTSurfaceDelegate>

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties;

- (RSUIViewRegistryObjC *)viewRegistry;

@end
