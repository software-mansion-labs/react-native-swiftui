
#import "RSUISurfaceView.h"
#import "RSUISurface.h"

#import <ReactSwiftUI-Swift.h>

@implementation RSUISurfaceView {
  RSUISurfaceContentView *_contentView;
}

- (instancetype)initWithSurface:(RCTSurface *)surface viewRegistry:(RSUIViewRegistry *)viewRegistry
{
  if (self = [super initWithSurface:surface]) {
    _contentView = [[RSUISurfaceContentView alloc] initWithViewRegistry:viewRegistry surfaceTag:surface.rootTag];
  }
  return self;
}

- (void)addSubview:(UIView *)view
{
  if (_contentView.superview != self) {
    [super addSubview:_contentView];
  }
  [_contentView addSubview:view];
}

- (void)layoutSubviews
{
  _contentView.frame = self.frame;
}

- (void)mountContentView
{
  [super addSubview:_contentView];
}

@end
