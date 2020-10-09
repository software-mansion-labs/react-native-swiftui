
#pragma once

char const RSUITextComponentName[] = "RSUITextView";

class RSUITextProps : public Props, public BaseTextProps, public RSUIDynamicProps {
public:
  RSUITextProps() {}
  RSUITextProps(const RSUITextProps &sourceProps, const RawProps &rawProps)
    : Props(sourceProps, rawProps),
      BaseTextProps::BaseTextProps(sourceProps, rawProps),
      RSUIDynamicProps(rawProps) {};
};

class RSUITextShadowNode : public ConcreteShadowNode<RSUITextComponentName, ShadowNode, RSUITextProps, TextEventEmitter>, public BaseTextShadowNode {
public:
  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteShadowNode::BaseTraits();

#ifdef ANDROID
    traits.set(ShadowNodeTraits::Trait::FormsView);
#endif

    return traits;
  }

  using ConcreteShadowNode::ConcreteShadowNode;
};

using RSUITextDescriptor = ConcreteComponentDescriptor<RSUITextShadowNode>;
