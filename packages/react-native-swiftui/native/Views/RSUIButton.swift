
import SwiftUI

struct RSUIButtonStyle: ButtonStyle {
  let onPressChange: (Bool) -> Void

  func makeBody(configuration: Configuration) -> some View {
    onPressChange(configuration.isPressed)
    return configuration.label
  }
}

final class RSUIButton: RSUIView {
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

  func render(props: RSUIProps) -> some View {
    Button(action: pressAction, label: {
      Children(self)
    })
    .buttonStyle(RSUIButtonStyle(onPressChange: onPressChange))
  }
}
