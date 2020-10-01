
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

  public var body: some View {
    let props = descriptor.props
    let layoutMetrics = descriptor.layoutMetrics

    let backgroundColor = props.color("backgroundColor", .clear)
    let foregroundColor = props.color("color", .white)

    let borderLeftColor = props.color("borderLeftColor", .clear)
    let borderLeftWidth = props.float("borderLeftWidth")

    let opacity = props.double("opacity", 1.0)

//    print(descriptor.name, props.dictionary())
    print("Rendering wrapper for \(descriptor.name) (\(descriptor.tag))")

    return descriptor.view.render()
      .frame(width: layoutMetrics.width, height: layoutMetrics.height, alignment: .topLeading)
      .background(backgroundColor)
      .foregroundColor(foregroundColor)
      .overlay(
        Rectangle()
          .frame(width: borderLeftWidth, height: nil, alignment: .leading)
          .foregroundColor(borderLeftColor),
        alignment: .leading
      )
      .offset(x: layoutMetrics.x, y: layoutMetrics.y)
      .opacity(opacity)
  }
}
