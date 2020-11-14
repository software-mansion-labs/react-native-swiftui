
import SwiftUI

struct AlignVertically<Content: View>: View {
  var alignment: VerticalAlignment
  var content: () -> Content

  var body: some View {
    switch alignment {
    case .top:
      return AnyView(
        VStack(spacing: 0) {
          content()
          Spacer(minLength: 0)
        }
      )
    case .center:
      return AnyView(
        VStack(spacing: 0) {
          Spacer(minLength: 0)
          content()
          Spacer(minLength: 0)
        }
      )
    case .bottom:
      return AnyView(
        VStack(spacing: 0) {
          Spacer(minLength: 0)
          content()
        }
      )
    default:
      return AnyView(
        VStack(spacing: 0) {
          content()
        }
      )
    }
  }
}
