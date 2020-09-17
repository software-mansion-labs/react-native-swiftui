
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
    let renderer = descriptor.view

    let backgroundColor = props.color("backgroundColor")
    let borderColor = props.color("borderColor")
    let borderWidth = props.float("borderLeftWidth")

//    print(descriptor.view, renderer.self)

    return renderer.render(props: descriptor.props)
      .frame(width: layoutMetrics.width, height: layoutMetrics.height, alignment: .topLeading)
      .background(backgroundColor)
      .border(borderColor, width: borderWidth)
      .offset(x: layoutMetrics.x, y: layoutMetrics.y)
  }
}
