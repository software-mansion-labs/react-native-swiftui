
#import <folly/dynamic.h>

#import <react/renderer/core/RawProps.h>
#import <react/renderer/core/RawPropsParser.h>
#import <react/renderer/graphics/Color.h>

#import <React/RCTFollyConvert.h>

#import "RSUIViewPropsObjC.h"

using namespace facebook::react;

@implementation RSUIViewPropsObjC {
  folly::dynamic _dynamicProps;
}

- (instancetype)init
{
  if (self = [super init]) {
    _dynamicProps = folly::dynamic::object();
  }
  return self;
}

- (void)updateDynamicProps:(folly::dynamic)propsPatch
{
  // We expect the patch to be of nonnull object type.
  if (!propsPatch.isObject()) {
    return;
  }
  _dynamicProps = folly::dynamic::merge(_dynamicProps, propsPatch);
}

#pragma mark - public getter

- (nullable id)rawValue:(NSString *)key
{
  return convertFollyDynamicToId([self get:key]);
}

- (nonnull NSDictionary<NSString *, id> *)dictionary
{
  return convertFollyDynamicToId(_dynamicProps) ?: @{};
}

- (BOOL)bool:(NSString *)key
{
  return (BOOL)([self get:key].asBool());
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

- (nullable NSNumber *)integer:(NSString *)key
{
  folly::dynamic value = [self get:key];
  if (value.isNumber()) {
    return @(value.asInt());
  } else {
    return @0;
  }
}

- (nullable NSNumber *)double:(NSString *)key
{
  return @([self get:key].asDouble());
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
  if (_dynamicProps == nil) {
    return folly::dynamic();
  }
  std::string keyString(key.UTF8String);

  for (auto &item : _dynamicProps.items()) {
    if (item.first.asString() == keyString) {
      return folly::dynamic(item.second);
    }
  }
  return folly::dynamic();
}

@end
