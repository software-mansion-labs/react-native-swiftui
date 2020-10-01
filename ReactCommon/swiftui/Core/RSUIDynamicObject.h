
NS_ASSUME_NONNULL_BEGIN

@interface RSUIDynamicObject : NSObject

#pragma mark - public getters

- (nullable id)rawValue:(NSString *)key;

- (nonnull NSDictionary<NSString *, id> *)dictionary;

- (BOOL)boolean:(NSString *)key :(BOOL)fallback;

- (CGFloat)float:(NSString *)key;

- (NSInteger)int:(NSString *)key;

- (double)double:(NSString *)key :(double)fallback;

- (nullable NSString *)string:(NSString *)key;

- (nullable NSArray *)array:(NSString *)key;

- (nullable NSDictionary<NSString *, id> *)dictionary:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
