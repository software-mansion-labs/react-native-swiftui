
#import <UIKit/UIView.h>

@protocol RCTComponentViewProtocol;

@interface RSUIComponentViewObjC : UIView <RCTComponentViewProtocol>

- (void)updateProps:(NSDictionary *)propsDict;

@end
