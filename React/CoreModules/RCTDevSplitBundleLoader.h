/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTBridgeModule.h>
#import <React/RCTJSScriptLoaderModule.h>
#import <React/RCTUIKit.h>

@interface RCTDevSplitBundleLoader : NSObject <RCTBridgeModule, RCTJSScriptLoaderModule>
@end
