
import SwiftUI

class ViewTagRef {
  let value: ViewTag
  init(_ value: ViewTag) {
    self.value = value
  }
}

public struct RSUIViewWrapper: View, Identifiable {

  // Implementing `Identifiable` protocol is necessary for ForEach used to render view's children.
  public var id: ViewTag {
    return descriptor.tag
  }

  @ObservedObject
  var descriptor: RSUIViewDescriptor

  // Computed properties for easier access to descriptor properties
  internal var props: RSUIViewProps { descriptor.props }
  internal var state: RSUIState { descriptor.state }
  internal var shadowNodeState: RSUIViewProps { descriptor.shadowNodeState }
  internal var eventEmitter: RSUIEventEmitter { descriptor.eventEmitter }
  internal var layoutMetrics: RSUILayoutMetrics { descriptor.layoutMetrics }

  func layout<InputType: View>(_ view: InputType) -> some View {
    let layoutMetrics = descriptor.layoutMetrics
    return view
      .frame(
        width: layoutMetrics.width,
        height: layoutMetrics.height,
        alignment: .topLeading
      )
  }

  func style<InputType: View>(_ view: InputType) -> some View {
    let backgroundColor = props.color("backgroundColor", .clear)
    let foregroundColor = props.color("color", .white)
    let opacity = props.double("opacity", 1.0)

    return view
      .background(backgroundColor)
      .foregroundColor(foregroundColor)
      .overlay(Border())
      .opacity(opacity)
  }

  func maybeApplyFrame<InputType: View>(_ view: InputType, traits: RSUIViewTraits) -> AnyView {
    if traits.contains(.Layoutable) {
      return AnyView(layout(view))
    } else {
      return AnyView(view)
    }
  }

  func maybeApplyStyles<InputType: View>(_ view: InputType, traits: RSUIViewTraits) -> AnyView {
    if traits.contains(.Styleable) {
      return AnyView(style(view))
    } else {
      return AnyView(view)
    }
  }

  public var body: some View {
    let traits = descriptor.traits()
    var result = descriptor.view.render()

    result = maybeApplyFrame(result, traits: traits)
    result = maybeApplyStyles(result, traits: traits)

    return result.offset(x: descriptor.layoutMetrics.x, y: descriptor.layoutMetrics.y)
  }

  // MARK: View helpers

  func Border() -> AnyView {
    let props = descriptor.props
    let width = props.cgFloat("borderWidth", 0.0)
    let color = props.color("borderColor", Color.clear)

    return AnyView(
      Rectangle()
        .fill(Color.clear)
        .overlay(
          Rectangle()
            .frame(
              width: nil,
              height: props.cgFloat("borderTopWidth", width),
              alignment: .top
            )
            .foregroundColor(props.color("borderTopColor", color)),
          alignment: .top
        )
        .overlay(
          Rectangle()
            .frame(
              width: props.cgFloat("borderRightWidth", width),
              height: nil,
              alignment: .trailing
            )
            .foregroundColor(props.color("borderRightColor", color)),
          alignment: .trailing
        )
        .overlay(
          Rectangle()
            .frame(
              width: nil,
              height: props.cgFloat("borderBottomWidth", width),
              alignment: .bottom
            )
            .foregroundColor(props.color("borderBottomColor", color)),
          alignment: .bottom
        )
        .overlay(
          Rectangle()
            .frame(
              width: props.cgFloat("borderLeftWidth", width),
              height: nil,
              alignment: .leading
            )
            .foregroundColor(props.color("borderLeftColor", color)),
          alignment: .leading
        )
    )
  }
}
