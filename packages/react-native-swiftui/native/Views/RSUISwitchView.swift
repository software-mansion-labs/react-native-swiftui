
import SwiftUI

final class RSUISwitchView: RSUIView {
  static var name: String { "Switch" }

  var isOn: Bool = false

  func render(props: RSUIProps) -> some View {
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

    #if canImport(UIKit)
    let offColor = props.color("tintColor", Color(UIColor.systemGray5))
    #else
    let offColor = props.color("tintColor", Color(NSColor.systemGray))
    #endif

    #if os(iOS)
    if #available(iOS 14.0, *) {
      return AnyView(
        Toggle(isOn: valueBinding) { Children(self) }
          .toggleStyle(SwitchToggleStyle(tint: offColor))
      )
    }
    #endif

    return AnyView(Toggle(isOn: valueBinding) { Children(self) })
  }
}
