
#import <React/RCTFollyConvert.h>

#import "RSUIEventEmitterObjC.h"
#import "RSUIComponentDescriptor.h"

@implementation RSUIEventEmitterObjC {
  RSUIComponentEventEmitter *_internalEventEmitter;
}

- (void)setInternalEventEmitter:(const void *)internalEventEmitter
{
  _internalEventEmitter = (RSUIComponentEventEmitter *)internalEventEmitter;
}

- (void)dispatchEvent:(NSString *)eventName
              payload:(NSDictionary *)payload
             priority:(const int)priority
{
  const folly::dynamic dynamicPayload = convertIdToFollyDynamic(payload);
  _internalEventEmitter->dispatchEvent(eventName.UTF8String, dynamicPayload, (const facebook::react::EventPriority)priority);
}

@end
