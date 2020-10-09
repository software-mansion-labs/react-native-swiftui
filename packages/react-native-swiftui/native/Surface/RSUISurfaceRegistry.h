
NS_ASSUME_NONNULL_BEGIN

@class RSUISurface;

typedef NSInteger ReactTag;
typedef void (^RSUISurfaceEnumeratorBlock)(NSEnumerator<RSUISurface *> *enumerator);

/**
 * Registry of Surfaces.
 * Incapsulates storing Surface objects and querying them by root tag.
 * All methods of the registry are thread-safe.
 * The registry stores Surface objects as weak references.
 */
@interface RSUISurfaceRegistry : NSObject

- (void)enumerateWithBlock:(RSUISurfaceEnumeratorBlock)block;

/**
 * Adds Surface object into the registry.
 * The registry does not retain Surface references.
 */
- (void)registerSurface:(RSUISurface *)surface;

/**
 * Removes Surface object from the registry.
 */
- (void)unregisterSurface:(RSUISurface *)surface;

/**
 * Returns stored Surface object by given root tag.
 * If the registry does not have such Surface registered, returns `nil`.
 */
- (nullable RSUISurface *)surfaceForRootTag:(ReactTag)rootTag;

@end

NS_ASSUME_NONNULL_END
