
import SwiftUI

open class RSUIAnimation: RSUIView {
  public override class var viewName: String { "RSUIAnimation" }

  func createBaseAnimation(type: String, duration: Double) -> Animation {
    switch type {
    case "easeIn":
      return Animation.easeIn(duration: duration)
    case "easeOut":
      return Animation.easeOut(duration: duration)
    case "easeInOut":
      return Animation.easeInOut(duration: duration)
    case "linear":
      return Animation.linear(duration: duration)
    default:
      return Animation.default
    }
  }

  func createAnimation() -> Animation {
    let animation = createBaseAnimation(
      type: props.string("type", "default"),
      duration: props.double("duration", 0.35)
    )
    // TODO: apply other parameters like delay, repeats, speed
    return animation
  }

  public override func render() -> AnyView {
    return AnyView(
      Children()
        .animation(createAnimation())
    )
  }
}
