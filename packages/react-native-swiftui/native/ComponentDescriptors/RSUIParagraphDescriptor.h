
#pragma once

#import <react/renderer/attributedstring/conversions.h>
#import <react/renderer/components/text/ParagraphComponentDescriptor.h>

#import "RSUIComponentDescriptor.h"

using namespace facebook::react;

char const RSUIParagraphComponentName[] = "RSUIParagraphView";

template <Float (*RoundingFunction)(Float)>
Float roundToPixel(Float value, Float scaleFactor) {
  return RoundingFunction(value * scaleFactor) / scaleFactor;
}

template <Float (*RoundingFunction)(Float)>
facebook::react::Point roundToPixel(facebook::react::Point value, Float scaleFactor) {
  return facebook::react::Point{roundToPixel<RoundingFunction>(value.x, scaleFactor),
               roundToPixel<RoundingFunction>(value.y, scaleFactor)};
}

template <Float (*RoundingFunction)(Float)>
facebook::react::Size roundToPixel(facebook::react::Size value, Float scaleFactor) {
  return facebook::react::Size{roundToPixel<RoundingFunction>(value.width, scaleFactor),
              roundToPixel<RoundingFunction>(value.height, scaleFactor)};
}

class RSUIParagraphProps : public ParagraphProps, public RSUIDynamicProps {
public:
  RSUIParagraphProps() {}

  RSUIParagraphProps(const RSUIParagraphProps &sourceProps, const RawProps &rawProps)
    : ParagraphProps(sourceProps, rawProps), RSUIDynamicProps(rawProps) {}
};

class RSUIParagraphState : public RSUIComponentState {
public:
  RSUIParagraphState() {}
  RSUIParagraphState(AttributedString const &attributedString, ParagraphAttributes const &paragraphAttributes, SharedTextLayoutManager const &layoutManager)
    : attributedString(attributedString),
      paragraphAttributes(paragraphAttributes),
      layoutManager(layoutManager) {}

  /*
   * All content of <Paragraph> component represented as an `AttributedString`.
   */
 AttributedString attributedString;

  /*
   * Represents all visual attributes of a paragraph of text represented as
   * a ParagraphAttributes.
   */
  ParagraphAttributes paragraphAttributes;

  /*
   * `TextLayoutManager` provides a connection to platform-specific
   * text rendering infrastructure which is capable to render the
   * `AttributedString`.
   */
  SharedTextLayoutManager layoutManager;

  folly::dynamic getDynamic() const;
};

// Copied from `react/renderer/components/text/conversions.h` in order to expose it to iOS as well.
inline folly::dynamic toDynamic(RSUIParagraphState const &paragraphState) {
  folly::dynamic newState = folly::dynamic::object();
  newState["attributedString"] = toDynamic(paragraphState.attributedString);
  newState["paragraphAttributes"] = toDynamic(paragraphState.paragraphAttributes);
  newState["hash"] = newState["attributedString"]["hash"];
  return newState;
}

inline folly::dynamic RSUIParagraphState::getDynamic() const {
  return toDynamic(*this);
}

class RSUIParagraphShadowNode : public ConcreteViewShadowNode<RSUIParagraphComponentName, RSUIParagraphProps, ParagraphEventEmitter, RSUIParagraphState>, public BaseTextShadowNode {
public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;
  using Size = facebook::react::Size;

  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::LeafYogaNode);
    traits.set(ShadowNodeTraits::Trait::TextKind);

#ifdef ANDROID
    // Unsetting `FormsStackingContext` trait is essential on Android where we
    // can't mount views inside `TextView`.
    traits.unset(ShadowNodeTraits::Trait::FormsStackingContext);
#endif

    return traits;
  }

  /*
   * Associates a shared TextLayoutManager with the node.
   * `ParagraphShadowNode` uses the manager to measure text content
   * and construct `ParagraphState` objects.
   */
  void setTextLayoutManager(SharedTextLayoutManager textLayoutManager);

#pragma mark - LayoutableShadowNode

  void layout(LayoutContext layoutContext) override;
  Size measureContent(
      LayoutContext const &layoutContext,
      LayoutConstraints const &layoutConstraints) const override;

  /*
   * Internal representation of the nested content of the node in a format
   * suitable for future processing.
   */
  class Content final {
   public:
    AttributedString attributedString;
    ParagraphAttributes paragraphAttributes;
    Attachments attachments;
  };

 private:
  /*
   * Builds (if needed) and returns a reference to a `Content` object.
   */
  Content const &getContent(LayoutContext const &layoutContext) const;

  /*
   * Builds and returns a `Content` object with given `layoutConstraints`.
   */
  Content getContentWithMeasuredAttachments(
      LayoutContext const &layoutContext,
      LayoutConstraints const &layoutConstraints) const;

  /*
   * Creates a `State` object (with `AttributedText` and
   * `TextLayoutManager`) if needed.
   */
  void updateStateIfNeeded(Content const &content);

  SharedTextLayoutManager textLayoutManager_;

  /*
   * Cached content of the subtree started from the node.
   */
  mutable better::optional<Content> content_{};

#pragma mark - BaseTextShadowNode

public:
  static void buildAttributedString(
      TextAttributes const &baseTextAttributes,
      ShadowNode const &parentNode,
      AttributedString &outAttributedString,
      Attachments &outAttachments);
};

class RSUIParagraphDescriptor final : public RSUIComponentDescriptor<RSUIParagraphShadowNode> {

public:
  RSUIParagraphDescriptor(ComponentDescriptorParameters const &parameters)
    : RSUIComponentDescriptor<RSUIParagraphShadowNode>(parameters) {
      textLayoutManager_ = std::make_shared<TextLayoutManager>(contextContainer_);
  }

  virtual SharedProps interpolateProps(
      float animationProgress,
      const SharedProps &props,
      const SharedProps &newProps) const override {
    SharedProps interpolatedPropsShared = cloneProps(newProps, {});

    interpolateViewProps(
        animationProgress, props, newProps, interpolatedPropsShared);

    return interpolatedPropsShared;
  };

 protected:
  void adopt(UnsharedShadowNode shadowNode) const override {
    ConcreteComponentDescriptor::adopt(shadowNode);

    assert(std::dynamic_pointer_cast<RSUIParagraphShadowNode>(shadowNode));
    auto paragraphShadowNode =
        std::static_pointer_cast<RSUIParagraphShadowNode>(shadowNode);

    // `ParagraphShadowNode` uses `TextLayoutManager` to measure text content
    // and communicate text rendering metrics to mounting layer.
    paragraphShadowNode->setTextLayoutManager(textLayoutManager_);

    paragraphShadowNode->dirtyLayout();

    // All `ParagraphShadowNode`s must have leaf Yoga nodes with properly
    // setup measure function.
    paragraphShadowNode->enableMeasurement();
  }

private:
  SharedTextLayoutManager textLayoutManager_;
};
