
import SwiftUI

public protocol RSUIViewProtocol {
  associatedtype RenderReturnType: View

  static var viewName: String { get }

  init(_ descriptor: RSUIViewDescriptor)

  func render() -> Self.RenderReturnType
}
