
import SwiftUI

open class RSUIHostingView: RSUIView {
  public override class var viewName: String { "RootView" }

  public override func render() -> AnyView {
    let _ = print("RSUIHostingView, children count", descriptor.children.count)
    return AnyView(Children())
  }
}
