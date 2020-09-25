
import SwiftUI

class ViewTagRef {
  let value: ViewTag
  init(_ value: ViewTag) {
    self.value = value
  }
}

public struct RSUIViewWrapper: View, Identifiable {
  public var id: ObjectIdentifier {
    return ObjectIdentifier(ViewTagRef(descriptor.tag))
  }

  @ObservedObject
  var descriptor: RSUIViewDescriptor

  public var body: some View {
    let props = descriptor.props
    let layoutMetrics = descriptor.layoutMetrics

    let backgroundColor = props.color("backgroundColor")
    let foregroundColor = props.color("color")

    let borderLeftColor = props.color("borderLeftColor")
    let borderLeftWidth = props.float("borderLeftWidth")

    let opacity = props.double("opacity", default: 1.0)

//    print(descriptor.name, props.dictionary())

    return descriptor.view?.render()
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
