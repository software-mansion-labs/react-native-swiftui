
import SwiftUI

/**
 * Specialized protocol of `RSUIAnyView` that adds `render` function with associated return type.
 */
public protocol RSUIView: RSUIAnyView {
  associatedtype RenderReturnType: View

  /**
   * Returns what to render. Returned value must implement `View` protocol.
   */
  @ViewBuilder
  func render(props: RSUIProps) -> Self.RenderReturnType
}

extension RSUIView {
  /**
   * Stub for method required by `RSUIAnyView` that maps generic return type to type-erased `AnyView`.
   * Don't override it.
   */
  func renderAny(props: RSUIProps) -> AnyView {
    return AnyView(render(props: props))
  }
}
