
#import <React/RCTComponentViewProtocol.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <react/renderer/components/view/ViewComponentDescriptor.h>

#import "RSUIComponentViewObjC.h"

#import <ReactSwiftUI-Swift.h>

using namespace facebook::react;

@implementation RSUIComponentViewObjC

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ViewComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  auto const &newViewProps = *std::static_pointer_cast<ViewProps const>(props);
  NSDictionary *propsDict = @{
    @"text": [NSString stringWithUTF8String:newViewProps.accessibilityLabel.c_str()],
    @"backgroundColor": [NSString stringWithUTF8String:newViewProps.accessibilityHint.c_str()],
  };
  [self updateProps:propsDict];
}

#pragma mark - interface exposed to Swift

- (void)updateProps:(NSDictionary *)propsDict {}

@end

Class<RCTComponentViewProtocol> RSUIViewCls(void)
{
  return RSUIComponentView.class;
}
