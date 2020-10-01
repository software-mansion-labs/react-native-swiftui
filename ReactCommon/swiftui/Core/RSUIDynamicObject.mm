
#import <folly/dynamic.h>

#import <react/renderer/core/RawProps.h>
#import <react/renderer/core/RawPropsParser.h>
#import <react/renderer/graphics/Color.h>

#import <React/RCTFollyConvert.h>

#import "RSUIDynamicObject.h"

using namespace facebook::react;

@implementation RSUIDynamicObject {
  folly::dynamic _object;
}

- (instancetype)init
{
  return [self initWithDynamicObject:folly::dynamic::object()];
}

- (instancetype)initWithDynamicObject:(folly::dynamic)object
{
  if (self = [super init]) {
    _object = object;
  }
  return self;
}

- (instancetype)mergeWith:(folly::dynamic)object
{
  return [[self.class alloc] initWithDynamicObject:folly::dynamic::merge(_object, object)];
}

- (void)updateObject:(folly::dynamic)patch
{
  // We expect the patch to be of nonnull object type.
  if (!patch.isObject()) {
    return;
  }
  _object = folly::dynamic::merge(_object, patch);
}

#pragma mark - public getters

- (nullable id)rawValue:(NSString *)key
{
  return convertFollyDynamicToId([self get:key]);
}

- (nonnull NSDictionary<NSString *, id> *)dictionary
{
  return convertFollyDynamicToId(_object) ?: @{};
}

- (BOOL)boolean:(NSString *)key :(BOOL)fallback
{
  folly::dynamic value = [self get:key];
  return value.isBool() ? value.asBool() : fallback;
}

- (CGFloat)float:(NSString *)key
{
  folly::dynamic value = [self get:key];
  if (value.isDouble()) {
    return CGFloat(value.asDouble());
  } else {
    return CGFloat();
  }
}

- (NSInteger)int:(NSString *)key
{
  folly::dynamic value = [self get:key];
  if (value.isNumber()) {
    return value.asInt();
  } else {
    return 0;
  }
}

- (double)double:(NSString *)key :(double)fallback
{
  folly::dynamic value = [self get:key];
  return value.isDouble() ? value.asDouble() : fallback;
}

- (nullable NSString *)string:(NSString *)key
{
  folly::dynamic value = [self get:key];
  if (!value.isString()) {
    return nil;
  }

  std::string string = value.asString();
  return [[NSString alloc] initWithBytes:string.c_str()
                                  length:string.size()
                                encoding:NSUTF8StringEncoding];
}

- (nullable NSArray *)array:(NSString *)key
{
  folly::dynamic value = [self get:key];
  NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:value.size()];
  for (auto &item : value) {
    [array addObject:convertFollyDynamicToId(item)];
  }
  return array;
}

- (nullable NSDictionary<NSString *, id> *)dictionary:(NSString *)key
{
  if (!_object.isObject()) {
    return nil;
  }
  folly::dynamic value = [self get:key];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:value.size()];
  for (auto &item : value.items()) {
    dict[convertFollyDynamicToId(item.first)] = convertFollyDynamicToId(item.second);
  }
  return dict;
}

#pragma mark - private getters

- (folly::dynamic)get:(NSString *)key
{
  if (_object == nil) {
    return folly::dynamic();
  }
  std::string keyString(key.UTF8String);

  for (auto &item : _object.items()) {
    if (item.first.asString() == keyString) {
      return folly::dynamic(item.second);
    }
  }
  return folly::dynamic();
}

@end
