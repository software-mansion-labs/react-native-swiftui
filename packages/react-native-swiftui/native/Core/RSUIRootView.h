
#import <React/RCTSurfaceHostingView.h>

#import "RSUIViewRegistryObjC.h"
#import "RSUIAppContext.h"

@interface RSUIRootView : RCTSurfaceHostingView <RCTSurfaceDelegate>

@property (nonatomic, strong, readonly) RSUIAppContext *appContext;

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties;

- (RSUIViewRegistryObjC *)viewRegistry;

@end
