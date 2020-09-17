
import SwiftUI

public final class RSUIAnyView: RSUIViewProtocol {
  public class var viewName: String { "AnyView" }

  private let _render: (RSUIViewProps) -> ReturnViewType

  init<ViewType>(_ view: ViewType) where ViewType: RSUIView {
    _render = view.render
  }

  public func render(props: RSUIViewProps) -> AnyView {
    return AnyView(_render(props))
  }
}
