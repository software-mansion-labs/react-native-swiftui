
#pragma once

#import <react/renderer/components/text/conversions.h>
#import <react/renderer/components/view/ViewComponentDescriptor.h>

using namespace facebook::react;

// `View` is temporary to override standard view.
// See also `RCTFabricComponentsPlugins`, those values must match.
char const RSUIComponentName[] = "RSUIView";

class RSUIDynamicProps {
public:
  RSUIDynamicProps() {}

  RSUIDynamicProps(const RawProps &rawProps) {
    dynamicProps_ = (folly::dynamic)rawProps;
  }

  folly::dynamic getProps() const {
    return dynamicProps_;
  };

private:
  folly::dynamic dynamicProps_ = folly::dynamic::object();
};

class RSUIComponentProps : public ViewProps, public RSUIDynamicProps {
public:
  RSUIComponentProps() {}

  RSUIComponentProps(const RSUIComponentProps &sourceProps, const RawProps &rawProps)
    : ViewProps(sourceProps, rawProps), RSUIDynamicProps(rawProps) {}
};

class RSUIComponentEventEmitter : public ViewEventEmitter {
public:
  using ViewEventEmitter::ViewEventEmitter;
  // EventEmitter::dispatchEvent is declared as protected,
  // so we add our own public method with different signature (C-style string).
  void dispatchEvent(
                     const char* type,
                     const folly::dynamic &payload,
                     const EventPriority &priority = EventPriority::AsynchronousBatched) const {
    EventEmitter::dispatchEvent(std::string(type), payload, priority);
  }
};

class RSUIComponentState {
public:
  folly::dynamic getDynamic() const {
    return folly::dynamic::object();
  }
};

using RSUIComponentShadowNode = ConcreteViewShadowNode<RSUIComponentName, RSUIComponentProps, RSUIComponentEventEmitter, RSUIComponentState>;

template <typename ShadowNode = RSUIComponentShadowNode>
class RSUIComponentDescriptor : public ConcreteComponentDescriptor<ShadowNode> {
public:
  RSUIComponentDescriptor(ComponentDescriptorParameters const &parameters)
    : ConcreteComponentDescriptor<ShadowNode>(parameters) {}

  ComponentHandle getComponentHandle() const override {
    return reinterpret_cast<ComponentHandle>(getComponentName());
  }

  ComponentName getComponentName() const override {
    return std::static_pointer_cast<std::string const>(this->flavor_)->c_str();
  }
};
