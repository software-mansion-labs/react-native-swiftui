
import SwiftUI

open class RSUIRect: RSUIView {
  public override class var viewName: String { "RSUIRect" }

  public override class func traits() -> RSUIViewTraits { [] }

  public override func render() -> AnyView {
    let offsetX = props.cgFloat("offsetX", 0.0)
    let offsetY = props.cgFloat("offsetY", 0.0)
    let alignment = props.alignment("alignment", .center)

    return AnyView(
      AlignContainer(alignment: alignment) {
        Rectangle()
          .fill(props.color("fill", Color.black))
          .frame(
            width: props.cgFloat("width", descriptor.layoutMetrics.width),
            height: props.cgFloat("height", descriptor.layoutMetrics.height)
          )
          .overlay(
            Rectangle()
              .strokeBorder(
                props.color("stroke", Color.clear),
                style: StrokeStyle(
                  lineWidth: props.cgFloat("strokeWidth", 1.0),
                  lineCap: props.lineCap("strokeLineCap"),
                  lineJoin: props.lineJoin("strokeLineJoin"),
                  dash: props.array("strokeDashes", [] as [CGFloat]),
                  dashPhase: props.cgFloat("strokeDashPhase", 0.0)
                )
              )
          )
          .overlay(Children())
      }
      .offset(x: offsetX, y: offsetY)
    )
  }
}
