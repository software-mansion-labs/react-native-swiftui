
#import <mutex>

#import <React/RCTSurfaceDelegate.h>
#import <React/RCTSurfaceView+Internal.h>
#import <React/RCTUIManagerUtils.h>
#import <React/RCTUtils.h>

#import "RSUISurface.h"
#import "RSUISurfaceView.h"
#import "RSUISurfacePresenter.h"

@implementation RSUISurface {
  // Immutable
  RSUISurfacePresenter *_surfacePresenter;
  NSString *_moduleName;

  // Protected by `_mutex`
  std::mutex _mutex;
  NSDictionary *_properties;
  RCTSurfaceStage _stage;
  CGSize _minimumSize;
  CGSize _maximumSize;
  CGPoint _viewportOffset;
  CGSize _intrinsicSize;

  // Main thread only
  RSUISurfaceView *_Nullable _view;
}

@synthesize delegate = _delegate;
@synthesize rootTag = _rootTag;

- (instancetype)initWithSurfacePresenter:(RSUISurfacePresenter *)surfacePresenter
                              moduleName:(NSString *)moduleName
                       initialProperties:(NSDictionary *)initialProperties
{
  if (self = [super init]) {
    _surfacePresenter = surfacePresenter;
    _moduleName = moduleName;
    _properties = [initialProperties copy];
    _rootTag = [RCTAllocateRootViewTag() integerValue];

    _minimumSize = CGSizeZero;
    _maximumSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);

    _stage = RCTSurfaceStageSurfaceDidInitialize;
  }
  return self;
}

- (void)dealloc
{
  [self stop];
}

#pragma mark - Immutable Properties (no need to enforce synchronization)

- (NSString *)moduleName
{
  return _moduleName;
}

- (NSNumber *)rootViewTag
{
  return @(_rootTag);
}

#pragma mark - Main-Threaded Routines

- (nonnull RSUISurfaceView *)view
{
  RCTAssertMainQueue();

  if (!_view) {
    _view = [[RSUISurfaceView alloc] initWithSurface:(RCTSurface *)self viewRegistry:_surfacePresenter.viewRegistry];
  }
  return _view;
}

- (BOOL)start
{
  if (![self setStage:RCTSurfaceStageStarted]) {
    return NO;
  }
  [_surfacePresenter registerSurface:self];
  return YES;
}

- (BOOL)stop
{
  if (![self setStage:RCTSurfaceStageStarted]) {
    return NO;
  }
  [_surfacePresenter unregisterSurface:self];
  return YES;
}

#pragma mark - Stage management

- (RCTSurfaceStage)stage
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _stage;
}

- (BOOL)setStage:(RCTSurfaceStage)stage
{
  return [self setStage:stage setOrUnset:YES];
}

- (BOOL)unsetStage:(RCTSurfaceStage)stage
{
  return [self setStage:stage setOrUnset:NO];
}

- (BOOL)setStage:(RCTSurfaceStage)stage setOrUnset:(BOOL)setOrUnset
{
  RCTSurfaceStage updatedStage;
  {
    std::lock_guard<std::mutex> lock(_mutex);

    if (setOrUnset) {
      updatedStage = (RCTSurfaceStage)(_stage | stage);
    } else {
      updatedStage = (RCTSurfaceStage)(_stage & ~stage);
    }

    if (updatedStage == _stage) {
      return NO;
    }

    _stage = updatedStage;
  }

  [self propagateStageChange:updatedStage];
  return YES;
}

- (void)propagateStageChange:(RCTSurfaceStage)stage
{
  // Updating the `view`
  RCTExecuteOnMainQueue(^{
    self->_view.stage = stage;
  });

  // Notifying the `delegate`
  id<RCTSurfaceDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(surface:didChangeStage:)]) {
    [delegate surface:(RCTSurface *)self didChangeStage:stage];
  }
}

#pragma mark - Properties management

- (NSDictionary *)properties
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _properties;
}

- (void)setProperties:(NSDictionary *)properties
{
  {
    std::lock_guard<std::mutex> lock(_mutex);
    if ([properties isEqualToDictionary:_properties]) {
      return;
    }
    _properties = [properties copy];
  }
  [_surfacePresenter setProps:properties surface:self];
}

#pragma mark - Layout

- (CGSize)sizeThatFitsMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
  return [_surfacePresenter sizeThatFitsMinimumSize:minimumSize maximumSize:maximumSize surface:self];
}

#pragma mark - Size Constraints

- (void)setSize:(CGSize)size
{
  [self setMinimumSize:size maximumSize:size viewportOffset:_viewportOffset];
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize viewportOffset:(CGPoint)viewportOffset
{
  {
    std::lock_guard<std::mutex> lock(_mutex);
    if (CGSizeEqualToSize(minimumSize, _minimumSize) && CGSizeEqualToSize(maximumSize, _maximumSize) &&
        CGPointEqualToPoint(viewportOffset, _viewportOffset)) {
      return;
    }

    _maximumSize = maximumSize;
    _minimumSize = minimumSize;
    _viewportOffset = viewportOffset;
  }

  [_surfacePresenter setMinimumSize:minimumSize maximumSize:maximumSize surface:self];
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
  [self setMinimumSize:minimumSize maximumSize:maximumSize viewportOffset:_viewportOffset];
}

- (CGSize)minimumSize
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _minimumSize;
}

- (CGSize)maximumSize
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _maximumSize;
}

- (CGPoint)viewportOffset
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _viewportOffset;
}

- (void)setIntrinsicSize:(CGSize)intrinsicSize
{
  {
    std::lock_guard<std::mutex> lock(_mutex);
    if (CGSizeEqualToSize(intrinsicSize, _intrinsicSize)) {
      return;
    }

    _intrinsicSize = intrinsicSize;
  }

  // Notifying `delegate`
  id<RCTSurfaceDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(surface:didChangeIntrinsicSize:)]) {
    [delegate surface:(RCTSurface *)self didChangeIntrinsicSize:intrinsicSize];
  }
}

- (CGSize)intrinsicSize
{
  std::lock_guard<std::mutex> lock(_mutex);
  return _intrinsicSize;
}

#pragma mark - Synchronous Waiting

- (BOOL)synchronouslyWaitFor:(NSTimeInterval)timeout
{
  return [_surfacePresenter synchronouslyWaitSurface:self timeout:timeout];
}

@end
