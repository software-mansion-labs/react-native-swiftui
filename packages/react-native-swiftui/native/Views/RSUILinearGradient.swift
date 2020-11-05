
import SwiftUI

open class RSUILinearGradient: RSUIView {
  public override class var viewName: String { "RSUILinearGradient" }

  // Linear gradient is not layoutable and not styleable — it fills in the entire parent's frame.
  public override class func traits() -> RSUIViewTraits { [] }

  public override func render() -> AnyView {
    guard let colors = props.map("colors", { $0.color() }), colors.count > 0 else {
      return AnyView(Rectangle())
    }

    let locations = props.map("locations", { $0.cgFloat() }) ?? colors.enumerated().map({ CGFloat($0.offset) / CGFloat(colors.count) })
    let gradient = Gradient(
      stops: (0..<colors.count).map { Gradient.Stop(color: colors[$0], location: locations[$0]) }
    )
    let linearGradient = LinearGradient(
      gradient: gradient,
      startPoint: props.unitPoint("from", .leading),
      endPoint: props.unitPoint("to", .trailing)
    )
    return AnyView(linearGradient)
  }
}
