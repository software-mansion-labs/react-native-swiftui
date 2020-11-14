
import SwiftUI

struct AlignHorizontally<Content: View>: View {
  var alignment: HorizontalAlignment
  var content: () -> Content

  var body: some View {
    switch alignment {
    case .leading:
      return AnyView(
        HStack(spacing: 0) {
          content()
          Spacer(minLength: 0)
        }
      )
    case .center:
      return AnyView(
        HStack(spacing: 0) {
          Spacer(minLength: 0)
          content()
          Spacer(minLength: 0)
        }
      )
    case .trailing:
      return AnyView(
        HStack(spacing: 0) {
          Spacer(minLength: 0)
          content()
        }
      )
    default:
      return AnyView(
        HStack(spacing: 0) {
          content()
        }
      )
    }
  }
}
