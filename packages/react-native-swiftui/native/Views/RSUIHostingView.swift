
import SwiftUI

final class RSUIHostingView: RSUIView {
  static var name: String { "RootView" }

  func render(props: RSUIProps) -> some View {
    Children(self)
  }
}
