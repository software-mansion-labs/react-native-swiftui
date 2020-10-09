
import SwiftUI

public enum RSUIViewTrait {
  case Layoutable
  case Styleable
}

public typealias RSUIViewTraits = [RSUIViewTrait]

public protocol RSUIViewProtocol {
  associatedtype RenderReturnType: View

  static var viewName: String { get }

  static func traits() -> RSUIViewTraits

  init(_ descriptor: RSUIViewDescriptor)

  func render() -> Self.RenderReturnType
}
