
#import "RSUIMountingManagerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger ReactTag;

@class RCTComponentViewRegistry;

/**
 * Manages mounting process.
 */
@interface RSUIMountingManager : NSObject

@property (nonatomic, weak) id<RSUIMountingManagerDelegate> delegate;

- (id)componentViewFactory;

- (id)viewRegistry;

/**
 * Schedule a mounting transaction to be performed on the main thread.
 * Can be called from any thread.
 */
//- (void)scheduleTransaction:(facebook::react::MountingCoordinator::Shared const &)mountingCoordinator;

/**
 * Dispatch a command to be performed on the main thread.
 * Can be called from any thread.
 */
- (void)dispatchCommand:(ReactTag)reactTag commandName:(NSString *)commandName args:(NSArray *)args;

//- (void)synchronouslyUpdateViewOnUIThread:(ReactTag)reactTag
//                             changedProps:(NSDictionary *)props
//                      componentDescriptor:(const facebook::react::ComponentDescriptor &)componentDescriptor;

@end

NS_ASSUME_NONNULL_END
