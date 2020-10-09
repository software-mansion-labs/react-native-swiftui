
#pragma once

#import <react/renderer/components/text/RawTextShadowNode.h>

#import "RSUIComponentDescriptor.h"

const char RSUIRawTextComponentName[] = "RSUIRawText";

class RSUIRawTextProps : public RawTextProps, public RSUIDynamicProps {
public:
  RSUIRawTextProps() {}

  RSUIRawTextProps(const RSUIRawTextProps &sourceProps, const RawProps &rawProps)
    : RawTextProps(sourceProps, rawProps),
      RSUIDynamicProps(rawProps) {}
};

//using RSUIRawTextShadowNode = ConcreteViewShadowNode<RSUIRawTextComponentName, RSUIRawTextProps, RSUIComponentEventEmitter, RSUIComponentState>;
//using RSUIRawTextShadowNode = ConcreteShadowNode<RSUIRawTextComponentName, ShadowNode, RSUIRawTextProps>;

class RSUIRawTextShadowNode : public ConcreteShadowNode<RSUIRawTextComponentName, ShadowNode, RSUIRawTextProps> {
public:
  using Shared = std::shared_ptr<RSUIRawTextShadowNode const>;

  /*
   * Creates a Shadow Node based on fields specified in a `fragment`.
   */
  RSUIRawTextShadowNode(
      ShadowNodeFragment const &fragment,
      ShadowNodeFamily::Shared const &family,
      ShadowNodeTraits traits)
    : ConcreteShadowNode(fragment, family, traits) {}

  /*
   * Creates a Shadow Node via cloning given `sourceShadowNode` and
   * applying fields from given `fragment`.
   * Note: `tag`, `surfaceId`, and `eventEmitter` cannot be changed.
   */
  RSUIRawTextShadowNode(const ShadowNode &sourceShadowNode, const ShadowNodeFragment &fragment)
    : ConcreteShadowNode(sourceShadowNode, fragment) {};
};

using RSUIRawTextDescriptor = RSUIComponentDescriptor<RSUIRawTextShadowNode>;
