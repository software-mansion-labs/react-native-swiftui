
#import "RSUIAppContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSUIEntryViewManagerObjC : NSObject

@property (nonatomic, nonnull, strong) RSUIAppContext *appContext;

- (instancetype)initWithModuleName:(NSString *)moduleName bundlePath:(NSString *)bundlePath;

- (NSInteger)surfaceTag;

@end

NS_ASSUME_NONNULL_END
