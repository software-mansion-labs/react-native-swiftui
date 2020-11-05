
import SwiftUI

open class RSUIShadow: RSUIView {
  public override class var viewName: String { "RSUIShadow" }

  public override class func traits() -> RSUIViewTraits { [.Layoutable] }

  public override func render() -> AnyView {
    let radius = props.cgFloat("radius", 0.0)
    let offsetX = props.cgFloat("offsetX", 0.0)
    let offsetY = props.cgFloat("offsetY", 0.0)
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
