
import SwiftUI

open class RSUIShadow: RSUIView {
  public override class var viewName: String { "RSUIShadow" }

  public override class func traits() -> RSUIViewTraits { [.Layoutable] }

  public override func render() -> AnyView {
    let radius = props.cgFloat("radius")
    let offsetX = props.cgFloat("offsetX")
    let offsetY = props.cgFloat("offsetY")
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
