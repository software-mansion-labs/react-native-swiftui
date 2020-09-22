
import SwiftUI

public protocol RSUIViewProtocol {
  associatedtype RenderReturnType: View

  static var viewName: String { get }

  init(state: RSUIViewProps)

  func render(props: RSUIViewProps) -> Self.RenderReturnType
}
