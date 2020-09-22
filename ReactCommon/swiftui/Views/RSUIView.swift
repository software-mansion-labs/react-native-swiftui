
import SwiftUI

open class RSUIView: RSUIViewProtocol {
  public class var viewName: String { "View" }

  internal let state: RSUIViewProps

  public required init(state: RSUIViewProps) {
    self.state = state
  }

  public func render(props: RSUIViewProps) -> AnyView {
    return AnyView(Children(props.children))
  }

  // MARK: View helpers

  func Children(_ children: [RSUIViewWrapper]) -> some View {
    return ZStack(alignment: .topLeading) {
      ForEach(children) { $0 }
    }
  }
}
