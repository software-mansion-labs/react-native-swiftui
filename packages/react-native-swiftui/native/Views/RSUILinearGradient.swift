
import SwiftUI

final class RSUILinearGradient: RSUIView {
  static var name: String { "RSUILinearGradient" }

  // Linear gradient is not layoutable and not styleable — it fills in the entire parent's frame.
  static func traits() -> RSUIViewTraits { [] }

  func render(props: RSUIProps) -> some View {
    guard let colors = props.map("colors", { $0.color() }), colors.count > 0 else {
      return LinearGradient(
        gradient: Gradient(colors: [Color.clear]),
        startPoint: .leading,
        endPoint: .trailing
      )
    }

    let locations = props.map("locations", { $0.cgFloat() }) ?? colors.enumerated().map({ CGFloat($0.offset) / CGFloat(colors.count - 1) })
    let gradient = Gradient(
      stops: (0..<colors.count).map { Gradient.Stop(color: colors[$0], location: locations[$0]) }
    )

    return LinearGradient(
      gradient: gradient,
      startPoint: props.unitPoint("from", .leading),
      endPoint: props.unitPoint("to", .trailing)
    )
  }
}
