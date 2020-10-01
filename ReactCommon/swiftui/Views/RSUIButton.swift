
import SwiftUI

struct RSUIButtonStyle: ButtonStyle {
  let onPressChange: (Bool) -> Void

  func makeBody(configuration: Configuration) -> some View {
    onPressChange(configuration.isPressed)
    return configuration.label
  }
}

open class RSUIButton: RSUIView {
  public override class var viewName: String { "RSUIButton" }

  var isPressed = false

  func pressAction() {
    self.isPressed = false
    eventEmitter.dispatchEvent("press")
  }

  func onPressChange(isPressed: Bool) {
    if self.isPressed != isPressed {
      self.isPressed = isPressed
      eventEmitter.dispatchEvent("activeStateChange", payload: ["state": isPressed], priority: .SynchronousUnbatched)
    }
  }

  public override func render() -> AnyView {
    return AnyView(
      Button(action: pressAction, label: {
        Children()
      })
      .buttonStyle(RSUIButtonStyle(onPressChange: onPressChange))
    )
  }
}
