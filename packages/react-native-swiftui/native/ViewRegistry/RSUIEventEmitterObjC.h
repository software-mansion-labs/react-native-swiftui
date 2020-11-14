
NS_ASSUME_NONNULL_BEGIN

@interface RSUIEventEmitterObjC : NSObject

- (void)setInternalEventEmitter:(const void *)internalEventEmitter;

- (void)dispatchEvent:(NSString *)eventName
              payload:(NSDictionary *)payload
             priority:(const int)priority;

@end

NS_ASSUME_NONNULL_END
