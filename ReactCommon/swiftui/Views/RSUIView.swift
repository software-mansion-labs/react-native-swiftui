
import SwiftUI

open class RSUIView: RSUIViewProtocol {
  public class var viewName: String { "View" }

  required public init() {}

  func Children(_ children: [RSUIViewWrapper]) -> some View {
    return ZStack(alignment: .topLeading) {
      ForEach(children) { $0 }
    }
  }

  internal func castView<ViewType: RSUIView>(to type: ViewType.Type) -> ViewType {
    return self as! ViewType
  }

  public func render(props: RSUIViewProps) -> AnyView {
    print(Self.self, props.viewTag, props.dictionary())

    return AnyView(Children(props.children))
  }
}
