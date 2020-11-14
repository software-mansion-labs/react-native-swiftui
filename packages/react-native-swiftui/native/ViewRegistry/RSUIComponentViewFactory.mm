
#import <better/better.h>

#import <React/RCTFollyConvert.h>

#import <react/renderer/componentregistry/ComponentDescriptorProviderRegistry.h>

#import "RSUIComponentViewFactory.h"

#import "RSUIParagraphDescriptor.h"
#import "RSUIRawTextDescriptor.h"
#import "RSUITextDescriptor.h"
#import "RSUIComponentDescriptor.h"

using namespace facebook::react;

@implementation RSUIComponentViewFactory {
  ComponentDescriptorProviderRegistry _providerRegistry;
  better::shared_mutex _mutex;
}

+ (const folly::dynamic)dynamicPropsValueForProps:(Props::Shared const &)props
{
  auto const dynamicProps = std::dynamic_pointer_cast<const RSUIDynamicProps>(props);
  return dynamicProps == nullptr ? folly::dynamic::object() : dynamicProps->getProps();
}

+ (const folly::dynamic)dynamicStateForState:(State::Shared const &)state
{
  auto const concreteState = std::dynamic_pointer_cast<const ConcreteState<RSUIParagraphState>>(state->getMostRecentState());
  return concreteState == nullptr ? folly::dynamic::object() : concreteState->getData().getDynamic();
}

+ (RSUIComponentViewFactory *)standardComponentViewFactory
{
  RSUIComponentViewFactory *factory = [[RSUIComponentViewFactory alloc] init];

  auto providerRegistry = &factory->_providerRegistry;

  providerRegistry->setComponentDescriptorProviderRequest([providerRegistry, factory](ComponentName requestedComponentName) {
    auto flavor = std::make_shared<std::string const>(requestedComponentName);
    auto componentName = ComponentName{ flavor->c_str() };
    auto componentHandle = reinterpret_cast<ComponentHandle>(componentName);

    static std::unordered_map<std::string, ComponentDescriptorConstructor *> componentsDescriptors = {
      {"Paragraph", concreteComponentDescriptorConstructor<RSUIParagraphDescriptor>},
      {"RawText", concreteComponentDescriptorConstructor<RSUIRawTextDescriptor>},
      {"Text", concreteComponentDescriptorConstructor<RSUITextDescriptor>},
      {"TextInput", concreteComponentDescriptorConstructor<RSUIParagraphDescriptor>},
      {"View", concreteComponentDescriptorConstructor<RSUIComponentDescriptor<RSUIComponentShadowNode>>},
    };

    NSLog(@"Requested for component %s", requestedComponentName);

    auto p = componentsDescriptors.find(requestedComponentName);
    auto componentConstructor = p != componentsDescriptors.end() ? p->second : concreteComponentDescriptorConstructor<RSUIComponentDescriptor<RSUIComponentShadowNode>>;

    providerRegistry->add(ComponentDescriptorProvider{
      componentHandle,
      componentName,
      flavor,
      componentConstructor
    });
  });
  return factory;
}

- (ComponentDescriptorRegistry::Shared)createComponentDescriptorRegistryWithParameters:(ComponentDescriptorParameters)parameters
{
  std::shared_lock<better::shared_mutex> lock(_mutex);
  return _providerRegistry.createComponentDescriptorRegistry(parameters);
}

@end

Class RSUIViewCls(void)
{
  return RSUIComponentViewFactory.class;
}
