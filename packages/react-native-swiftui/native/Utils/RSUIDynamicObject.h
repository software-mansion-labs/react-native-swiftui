
NS_ASSUME_NONNULL_BEGIN

@interface RSUIDynamicObject : NSObject

- (instancetype)initWithDynamicObject:(RSUIDynamicObject *)object;

#pragma mark - public getters

- (nullable id)rawValue:(nullable NSString *)key;

- (nonnull NSDictionary<NSString *, id> *)dictionary;

- (BOOL)boolean:(nullable NSString *)key :(BOOL)fallback;

- (NSInteger)int:(nullable NSString *)key :(NSInteger)fallback;

- (double)double:(nullable NSString *)key :(double)fallback;

- (nullable NSString *)string:(nullable NSString *)key;

- (nullable NSArray *)array:(nullable NSString *)key;

- (nullable NSArray<RSUIDynamicObject *> *)deepArray:(nullable NSString *)key;

- (nullable NSDictionary<NSString *, id> *)dictionary:(nullable NSString *)key;

@end

NS_ASSUME_NONNULL_END
