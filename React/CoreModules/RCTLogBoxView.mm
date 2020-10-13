/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTLogBoxView.h"

#import <React/RCTLog.h>
#import <React/RCTSurface.h>

@implementation RCTLogBoxView {
  RCTSurface *_surface;
}

- (instancetype)initWithFrame:(CGRect)frame
{
#if TARGET_OS_OSX
  if (self = [super init]) {
    self.backgroundColor = [NSColor clearColor];
  }
#else
  if ((self = [super initWithFrame:frame])) {
    self.windowLevel = UIWindowLevelStatusBar - 1;
    self.backgroundColor = [UIColor clearColor];
  }
#endif
  return self;
}

- (void)createRootViewController:(RCTUIView *)view
{
#if !TARGET_OS_OSX
  UIViewController *_rootViewController = [UIViewController new];
  _rootViewController.view = view;
  _rootViewController.view.backgroundColor = [UIColor clearColor];
  _rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  self.rootViewController = _rootViewController;
#endif
}

- (instancetype)initWithFrame:(CGRect)frame bridge:(RCTBridge *)bridge
{
  if ((self = [self initWithFrame:frame])) {
    _surface = [[RCTSurface alloc] initWithBridge:bridge moduleName:@"LogBox" initialProperties:@{}];

    [_surface start];
    [_surface setSize:frame.size];

    if (![_surface synchronouslyWaitForStage:RCTSurfaceStageSurfaceDidInitialMounting timeout:1]) {
      RCTLogInfo(@"Failed to mount LogBox within 1s");
    }

#if !TARGET_OS_OSX
    [self createRootViewController:(UIView *)_surface.view];
#endif
  }
  return self;
}

- (void)dealloc
{
#if !TARGET_OS_OSX
  [RCTSharedApplication().delegate.window makeKeyWindow];
#endif
}

- (void)show
{
  [self becomeFirstResponder];
#if !TARGET_OS_OSX
  [self makeKeyAndVisible];
#endif
}

@end
