
import SwiftUI

final class RSUIBlur: RSUIView {
  func render(props: RSUIProps) -> some View {
    return Children(self)
      .blur(
        radius: props.cgFloat("radius", 1.0)
      )
  }
}
