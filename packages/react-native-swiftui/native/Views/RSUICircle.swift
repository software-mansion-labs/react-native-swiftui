
import SwiftUI

open class RSUICircle: RSUIView {
  public override class var viewName: String { "RSUICircle" }

  public override class func traits() -> RSUIViewTraits { [] }

  public override func render() -> AnyView {
    let offsetX = props.cgFloat("offsetX", 0.0)
    let offsetY = props.cgFloat("offsetY", 0.0)
    let radius = props.cgFloat("radius", 0.0)
    let width = radius.isZero ? descriptor.layoutMetrics.width : radius * 2.0
    let height = radius.isZero ? descriptor.layoutMetrics.height : radius * 2.0
    let alignment = props.alignment("alignment", .center)

    return AnyView(
      AlignContainer(alignment: alignment) {
        Circle()
          .fill(props.color("fill", Color.black))
          .frame(width: width, height: height)
          .overlay(
            Circle()
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
