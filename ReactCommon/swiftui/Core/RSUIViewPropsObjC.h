
NS_ASSUME_NONNULL_BEGIN

@interface RSUIViewPropsObjC : NSObject

#pragma mark - public getters

- (nullable id)rawValue:(NSString *)key;

- (nonnull NSDictionary<NSString *, id> *)dictionary;

- (BOOL)bool:(NSString *)key;

- (CGFloat)float:(NSString *)key;

- (nullable NSNumber *)integer:(NSString *)key;

- (nullable NSNumber *)double:(NSString *)key;

- (nullable NSString *)string:(NSString *)key;

- (nullable NSArray *)array:(NSString *)key;

- (nullable NSDictionary<NSString *, id> *)dictionary:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
