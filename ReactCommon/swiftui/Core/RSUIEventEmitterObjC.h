
NS_ASSUME_NONNULL_BEGIN

@interface RSUIEventEmitterObjC : NSObject

- (void)setInternalEventEmitter:(const void *)internalEventEmitter;

- (void)dispatchEvent:(NSString *)eventName payload:(NSDictionary *)payload;

@end

NS_ASSUME_NONNULL_END
