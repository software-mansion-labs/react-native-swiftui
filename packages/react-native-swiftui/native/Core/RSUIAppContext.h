
#import <React/RCTBridge.h>
#import <React/RCTSurfaceProtocol.h>

#import "RSUIViewRegistryObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSUIAppContext : NSObject

/**
 * Surface object which is currently using to power the view.
 * Read-only.
 */
@property (nonatomic, strong, readwrite) id<RCTSurfaceProtocol> surface;

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties;

- (RSUIViewRegistryObjC *)viewRegistry;

@end

NS_ASSUME_NONNULL_END
