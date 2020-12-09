
#import <cxxreact/JSExecutor.h>
#import <ReactCommon/RCTTurboModuleManager.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/JSCExecutorFactory.h>
#import <React/RCTImageLoader.h>
#import <React/RCTLocalAssetImageLoader.h>
#import <React/RCTGIFImageDecoder.h>
#import <React/RCTNetworking.h>
#import <React/RCTHTTPRequestHandler.h>
#import <React/RCTDataRequestHandler.h>
#import <React/RCTFileRequestHandler.h>

#import <React/CoreModulesPlugins.h>
#import <ReactCommon/SampleTurboCxxModule.h>

#import "RSUIEntryViewManager.h"

#pragma mark - TurboModule provider

Class RSUITurboModuleClassProvider(const char *name) {
  return RCTCoreModulesClassProvider(name);
}

std::shared_ptr<facebook::react::TurboModule> RSUITurboModuleProvider(const std::string &name, std::shared_ptr<facebook::react::CallInvoker> jsInvoker) {
  return nullptr;
}

std::shared_ptr<facebook::react::TurboModule> RSUITurboModuleProvider(const std::string &name, const facebook::react::ObjCTurboModule::InitParams &params) {
  return nullptr;
}

#pragma mark - Entry view manager

@interface RSUIEntryViewManagerObjC() <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate>
@end

@implementation RSUIEntryViewManagerObjC {
  NSString *_bundlePath;
  RCTBridge *_bridge;
  RCTTurboModuleManager *_turboModuleManager;
}

- (instancetype)initWithModuleName:(NSString *)moduleName bundlePath:(NSString *)bundlePath
{
  if (self = [super init]) {
    _bundlePath = bundlePath;
    _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    _appContext = [[RSUIAppContext alloc] initWithBridge:_bridge moduleName:moduleName initialProperties:@{}];
    [_appContext.surface start];
  }
  return self;
}

- (NSInteger)surfaceTag
{
  return _appContext.surface.rootTag;
}

# pragma mark - RCTCxxBridgeDelegate

- (NSURL *)sourceURLForBridge:(__unused RCTBridge *)bridge
{
  NSString *bundlePrefix = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"RN_BUNDLE_PREFIX"];
  NSString *bundleRoot = [NSString stringWithFormat:@"%@%@", bundlePrefix, _bundlePath];
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:bundleRoot
                                                        fallbackResource:nil];
}

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                             delegate:self
                                                            jsInvoker:bridge.jsCallInvoker];
  [bridge setRCTTurboModuleRegistry:_turboModuleManager];

#if RCT_DEV
  /**
   * Eagerly initialize RCTDevMenu so CMD + d, CMD + i, and CMD + r work.
   * This is a stop gap until we have a system to eagerly init Turbo Modules.
   */
  [_turboModuleManager moduleForName:"RCTDevMenu"];
#endif

  __weak __typeof(self) weakSelf = self;
  return std::make_unique<facebook::react::JSCExecutorFactory>([weakSelf, bridge](facebook::jsi::Runtime &runtime) {
    if (!bridge) {
      return;
    }
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      facebook::react::RuntimeExecutor syncRuntimeExecutor = [&](std::function<void(facebook::jsi::Runtime &runtime_)> &&callback) {
        callback(runtime);
      };
      [strongSelf->_turboModuleManager installJSBindingWithRuntimeExecutor:syncRuntimeExecutor];
    }
  });
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RSUITurboModuleClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return RSUITurboModuleProvider(name, jsInvoker);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                       initParams:(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return RSUITurboModuleProvider(name, params);
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  if (moduleClass == RCTImageLoader.class) {
    return [[moduleClass alloc] initWithRedirectDelegate:nil loadersProvider:^NSArray<id<RCTImageURLLoader>> *{
      return @[[RCTLocalAssetImageLoader new]];
    } decodersProvider:^NSArray<id<RCTImageDataDecoder>> *{
      return @[[RCTGIFImageDecoder new]];
    }];
  } else if (moduleClass == RCTNetworking.class) {
    return [[moduleClass alloc] initWithHandlersProvider:^NSArray<id<RCTURLRequestHandler>> *{
      return @[
        [RCTHTTPRequestHandler new],
        [RCTDataRequestHandler new],
        [RCTFileRequestHandler new],
      ];
    }];
  }
  // No custom initializer here.
  return [moduleClass new];
}

@end
