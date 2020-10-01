
import SwiftUI

open class RSUIShadow: RSUIView {
  public override class var viewName: String { "RSUIShadow" }

  public override func render() -> AnyView {
    let radius = props.float("radius")
    let offsetX = props.float("offsetX")
    let offsetY = props.float("offsetY")
    let color = props.color("color", Color.black)
    let opacity = props.double("opacity", 0.33)

    return AnyView(
      Children()
        .shadow(
          color: color.opacity(opacity),
          radius: radius,
          x: offsetX,
          y: offsetY
        )
    )
  }
}
