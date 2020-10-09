
#import <React/RCTSurfaceProtocol.h>
#import <React/RCTSurfaceView.h>
#import <React/RCTSurface.h>

@class RSUISurfacePresenter;
@class RSUISurfaceView;

@interface RSUISurface : NSObject <RCTSurfaceProtocol>

- (instancetype)initWithSurfacePresenter:(RSUISurfacePresenter *)surfacePresenter
                              moduleName:(NSString *)moduleName
                       initialProperties:(NSDictionary *)initialProperties;

/**
 * Main thread only access.
 * Creates (if needed) and returns `UIView` instance which represents the Surface.
 * The Surface will cache and *retain* this object.
 * Returning the UIView instance does not mean that the Surface is ready
 * to execute and layout. It can be just a handler which Surface will use later
 * to mount the actual views.
 * RCTSurface does not control (or influence in any way) the size or origin
 * of this view. Some superview (or another owner) must use other methods
 * of this class to setup proper layout and interop interactions with UIKit
 * or another UI framework.
 * This method must be called only from the main queue.
 */
- (RSUISurfaceView *)view;

#pragma mark - Start & Stop

/**
 * Starts or stops the Surface.
 * A Surface object can be stopped and then restarted.
 * The starting process includes initializing all underlying React Native
 * infrastructure and running React app.
 * Surface stops itself on deallocation automatically.
 * Returns YES in case of success. Returns NO if the Surface is already
 * started or stopped.
 */
- (BOOL)start;
- (BOOL)stop;

#pragma mark - Layout: Setting the size constrains

/**
 * Previously set `minimumSize` layout constraint.
 * Defaults to `{0, 0}`.
 */
@property (atomic, assign, readonly) CGSize minimumSize;

/**
 * Previously set `maximumSize` layout constraint.
 * Defaults to `{CGFLOAT_MAX, CGFLOAT_MAX}`.
 */
@property (atomic, assign, readonly) CGSize maximumSize;

/**
 * Previously set `viewportOffset` layout constraint.
 * Defaults to `{0, 0}`.
 */
@property (atomic, assign, readonly) CGPoint viewportOffset;

/**
 * Simple shortcut to `-[RCTSurface setMinimumSize:size maximumSize:size]`.
 */
- (void)setSize:(CGSize)size;

#pragma mark - Layout: Measuring

/**
 * Measures the Surface with given constraints.
 * This method does not cause any side effects on the surface object.
 */
- (CGSize)sizeThatFitsMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize;

/**
 * Return the current size of the root view based on (but not clamp by) current
 * size constraints.
 */
@property (atomic, assign, readonly) CGSize intrinsicSize;

#pragma mark - Synchronous waiting

/**
 * Synchronously blocks the current thread up to given `timeout` until
 * the Surface is rendered.
 */
- (BOOL)synchronouslyWaitFor:(NSTimeInterval)timeout;

#pragma mark - Stage management

/**
 * Sets and clears given stage flags (bitmask).
 * Returns `YES` if the actual state was changed.
 */
- (BOOL)setStage:(RCTSurfaceStage)stage;
- (BOOL)unsetStage:(RCTSurfaceStage)stage;

@end
