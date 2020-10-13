/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTBridge.h>
#import <React/RCTSurfaceView.h>
#import <React/RCTUIKit.h>

#if TARGET_OS_OSX
@interface RCTLogBoxView : NSWindow

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame bridge:(RCTBridge *)bridge;

- (void)show;

@end
#else
@interface RCTLogBoxView : UIWindow

- (instancetype)initWithFrame:(CGRect)frame;

- (void)createRootViewController:(UIView *)view;

- (instancetype)initWithFrame:(CGRect)frame bridge:(RCTBridge *)bridge;

- (void)show;

@end
#endif
