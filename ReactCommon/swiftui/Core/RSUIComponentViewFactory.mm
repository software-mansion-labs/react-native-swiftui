
#import <React/RCTComponentViewProtocol.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <React/RCTFollyConvert.h>

#import <react/renderer/components/view/ViewComponentDescriptor.h>
#import <react/renderer/componentregistry/ComponentDescriptorProviderRegistry.h>

#import "RSUIComponentViewFactory.h"

using namespace facebook::react;

#pragma mark - C++ things needed to construct RSUIComponentDescriptor

// Those things cannot be declared in a header because we need to import C++ libs that if imported from the bridging header would cause compilation to fail. We can do this as we don't use them anywhere outside this file.

// `View` is temporary to override standard view. See also `RCTFabricComponentsPlugins`, those values must match.
char const RSUIComponentName[] = "RSUIView";

class RSUIComponentProps final : public ViewProps {
public:
  RSUIComponentProps() {}

  RSUIComponentProps(const RSUIComponentProps &sourceProps, const RawProps &rawProps)
    : ViewProps(sourceProps, rawProps),
      dynamicProps((folly::dynamic)rawProps) {}

  folly::dynamic dynamicProps;
};

class RSUIComponentEventEmitter : public ViewEventEmitter {
public:
  using ViewEventEmitter::ViewEventEmitter;

  void dispatchEvent(std::string const &type, folly::dynamic const &payload) const {}
};

class RSUIComponentState final {
public:
  std::shared_ptr<void> coordinator;
};

using RSUIComponentShadowNode = ConcreteViewShadowNode<RSUIComponentName, RSUIComponentProps, RSUIComponentEventEmitter, RSUIComponentState>;

class RSUIComponentDescriptor final : public ConcreteComponentDescriptor<RSUIComponentShadowNode> {
public:
  RSUIComponentDescriptor(ComponentDescriptorParameters const &parameters) : ConcreteComponentDescriptor(parameters) {}

  ComponentHandle getComponentHandle() const override {
    return reinterpret_cast<ComponentHandle>(getComponentName());
  }

  ComponentName getComponentName() const override {
    return std::static_pointer_cast<std::string const>(this->flavor_)->c_str();
  }
};

#pragma mark - Objective-C wrapper

@implementation RSUIComponentViewFactory {
  ComponentDescriptorProviderRegistry _providerRegistry;
  better::shared_mutex _mutex;
}

+ (folly::dynamic)dynamicPropsValueForProps:(Props::Shared const &)props
{
  auto const &castedProps = *std::static_pointer_cast<const RSUIComponentProps>(props);
  return castedProps.dynamicProps;
}

+ (RSUIComponentViewFactory *)standardComponentViewFactory
{
  RSUIComponentViewFactory *factory = [[RSUIComponentViewFactory alloc] init];

  auto providerRegistry = &factory->_providerRegistry;

  providerRegistry->setComponentDescriptorProviderRequest([providerRegistry, factory](ComponentName requestedComponentName) {
    auto flavor = std::make_shared<std::string const>(requestedComponentName);
    auto componentName = ComponentName{ flavor->c_str() };
    auto componentHandle = reinterpret_cast<ComponentHandle>(componentName);

    providerRegistry->add(ComponentDescriptorProvider{
      componentHandle,
      componentName,
      flavor,
      &concreteComponentDescriptorConstructor<RSUIComponentDescriptor>
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

Class<RCTComponentViewProtocol> RSUIViewCls(void)
{
  return RSUIComponentViewFactory.class;
}
