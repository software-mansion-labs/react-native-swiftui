
import SwiftUI

final class RSUIRect: RSUIView {
  static func traits() -> RSUIViewTraits { [] }

  func render(props: RSUIProps) -> some View {
    let layoutMetrics = descriptor.layoutMetrics
    let offsetX = props.cgFloat("offsetX", 0.0)
    let offsetY = props.cgFloat("offsetY", 0.0)
    let alignment = props.alignment("alignment", .center)

    return AlignContainer(alignment: alignment) {
      Rectangle()
        .fill(props.color("fill", Color.black))
        .frame(
          width: props.cgFloat("width", layoutMetrics.width),
          height: props.cgFloat("height", layoutMetrics.height)
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
        .overlay(Children(self))
    }
    .offset(x: offsetX, y: offsetY)
  }
}
