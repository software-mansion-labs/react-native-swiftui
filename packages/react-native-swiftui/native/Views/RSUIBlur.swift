
import SwiftUI

final class RSUIBlur: RSUIView {
  static var name: String { "RSUIBlur" }

  func render(props: RSUIProps) -> some View {
    return Children(self)
      .blur(
        radius: props.cgFloat("radius", 1.0)
      )
  }
}
