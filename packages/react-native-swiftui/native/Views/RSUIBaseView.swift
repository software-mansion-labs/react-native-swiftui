
import SwiftUI

final class RSUIBaseView: RSUIView {
  static var name: String { "View" }

  func render(props: RSUIProps) -> some View {
    ZStack(alignment: .topLeading) {
      Children(self)
    }
    .onTapGesture {
      self.eventEmitter.dispatchEvent("tap")
    }
    .onLongPressGesture {
      self.eventEmitter.dispatchEvent("longPress")
    }
  }
}
