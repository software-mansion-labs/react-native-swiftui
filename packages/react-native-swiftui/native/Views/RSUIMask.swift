
import SwiftUI

open class RSUIMask: RSUIView {
  public override class var viewName: String { "RSUIMask" }

  public override func render() -> AnyView {
    let children = descriptor.getChildren()

    if children.count < 2 {
      return AnyView(EmptyView())
    }

    return AnyView(
      ForEach(children[1..<children.count]) { $0 }
        .frame(width: layoutMetrics.width, height: layoutMetrics.height)
        .mask(children.first)
    )
  }
}
