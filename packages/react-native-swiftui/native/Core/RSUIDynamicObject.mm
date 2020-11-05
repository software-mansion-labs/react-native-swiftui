
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
  return [self initWithFollyObject:folly::dynamic::object()];
}

- (instancetype)initWithDynamicObject:(RSUIDynamicObject *)object
{
  if (self = [super init]) {
    _object = [object get:nil];
  }
  return self;
}

- (instancetype)initWithFollyObject:(folly::dynamic)object
{
  if (self = [super init]) {
    _object = object;
  }
  return self;
}

- (instancetype)mergeWith:(folly::dynamic)object
{
  return [[self.class alloc] initWithFollyObject:folly::dynamic::merge(_object, object)];
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

- (nullable id)rawValue:(nullable NSString *)key
{
  return convertFollyDynamicToId([self get:key]);
}

- (nonnull NSDictionary<NSString *, id> *)dictionary
{
  return convertFollyDynamicToId(_object) ?: @{};
}

- (BOOL)boolean:(nullable NSString *)key :(BOOL)fallback
{
  folly::dynamic value = [self get:key];
  return value.isBool() ? value.asBool() : fallback;
}

- (NSInteger)int:(nullable NSString *)key :(NSInteger)fallback
{
  folly::dynamic value = [self get:key];
  if (value.isNumber()) {
    return value.asInt();
  } else {
    return fallback;
  }
}

- (double)double:(nullable NSString *)key :(double)fallback
{
  folly::dynamic value = [self get:key];
  return value.isDouble() ? value.asDouble() : fallback;
}

- (nullable NSString *)string:(nullable NSString *)key
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

- (nullable NSArray *)array:(nullable NSString *)key
{
  folly::dynamic value = [self get:key];
  if (!value.isArray()) {
    return nil;
  }
  NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:value.size()];
  for (auto &item : value) {
    [array addObject:convertFollyDynamicToId(item)];
  }
  return array;
}

- (nullable NSArray<RSUIDynamicObject *> *)deepArray:(nullable NSString *)key
{
  folly::dynamic value = [self get:key];
  if (!value.isArray()) {
    return nil;
  }
  NSMutableArray<RSUIDynamicObject *> *array = [[NSMutableArray alloc] initWithCapacity:value.size()];
  for (auto &item : value) {
    [array addObject:[[self.class alloc] initWithFollyObject:item]];
  }
  return array;
}

- (nullable NSDictionary<NSString *, id> *)dictionary:(nullable NSString *)key
{
  folly::dynamic value = [self get:key];
  if (!value.isObject()) {
    return nil;
  }
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:value.size()];
  for (auto &item : value.items()) {
    dict[convertFollyDynamicToId(item.first)] = convertFollyDynamicToId(item.second);
  }
  return dict;
}

#pragma mark - private getters

- (folly::dynamic)get:(nullable NSString *)key
{
  if (_object == nil) {
    return folly::dynamic();
  }
  if (key == nil) {
    return _object;
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
