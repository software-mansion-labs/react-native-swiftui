
#import <React/RCTPrimitives.h>

NS_ASSUME_NONNULL_BEGIN

@class RSUIMountingManager;

@protocol RSUIMountingManagerDelegate <NSObject>

/*
 * Called right *before* execution of mount items which affect a Surface with
 * given `rootTag`.
 * Always called on the main queue.
 */
- (void)mountingManager:(RSUIMountingManager *)mountingManager willMountComponentsWithRootTag:(ReactTag)MountingManager;

/*
 * Called right *after* execution of mount items which affect a Surface with
 * given `rootTag`.
 * Always called on the main queue.
 */
- (void)mountingManager:(RSUIMountingManager *)mountingManager didMountComponentsWithRootTag:(ReactTag)rootTag;

@end

NS_ASSUME_NONNULL_END
