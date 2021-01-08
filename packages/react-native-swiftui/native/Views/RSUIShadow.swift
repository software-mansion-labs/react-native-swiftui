
import SwiftUI

final class RSUIShadow: RSUIView {
  static func traits() -> RSUIViewTraits { [.Layoutable] }

  func render(props: RSUIProps) -> some View {
    let radius = props.cgFloat("radius", 0.0)
    let offsetX = props.cgFloat("offsetX", 0.0)
    let offsetY = props.cgFloat("offsetY", 0.0)
    let color = props.color("color", Color.black)
    let opacity = props.double("opacity", 0.33)

    return Children(self)
      .shadow(
        color: color.opacity(opacity),
        radius: radius,
        x: offsetX,
        y: offsetY
      )
  }
}
