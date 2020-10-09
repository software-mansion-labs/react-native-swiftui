
import SwiftUI

open class RSUISwitchView: RSUIView {
  public override class var viewName: String { "Switch" }

  var isOn: Bool = false

  public override func render() -> AnyView {
    let valueBinding = Binding<Bool>(
      get: {
        return self.props.boolean("value", self.isOn)
      },
      set: {
        if self.props.boolean("value", self.isOn) != $0 {
          self.isOn = $0
          self.eventEmitter.dispatchEvent("change", payload: ["value": $0], priority: .SynchronousUnbatched)
        }
      }
    )

    let offColor = props.color("tintColor", Color(UIColor.systemGray5))

    if #available(iOS 14.0, *) {
      return AnyView(
        Toggle(isOn: valueBinding) { Children() }
          .toggleStyle(SwitchToggleStyle(tint: offColor))
      )
    } else {
      return AnyView(Toggle(isOn: valueBinding) { Children() })
    }
  }
}
