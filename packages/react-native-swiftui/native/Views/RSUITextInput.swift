
import SwiftUI
import Combine

final class RSUITextInput: RSUIView {
  static var name: String { "TextInput" }

  var textInput: String = ""

  func propsWillChange(newProps: RSUIProps) {
    if let newValue = newProps.string("text"), props.string("text") != newValue {
      textInput = newValue
    }
  }

  func onEditingChanged(changed: Bool) {
    if changed {
      eventEmitter.dispatchEvent("focus")
    } else {
      eventEmitter.dispatchEvent("blur")
    }
  }

  func onCommit() {
    eventEmitter.dispatchEvent("endEditing")
  }

  func onChanged(_ input: String) {
    eventEmitter.dispatchEvent("change", payload: ["text": input], priority: .SynchronousUnbatched)
  }

  func renderTextField() -> AnyView {
    let binding = Binding<String>(
      get: {
        return self.textInput
      },
      set: {
        if self.textInput != $0 {
          self.textInput = $0
          self.onChanged($0)
        }
      }
    )

    #if os(iOS)
    // TODO: Multiline text field requires more work.
    // Especially with updating the frame whenever the number of lines changes
    // and having a separate view/overlay for placeholder.
    if props.boolean("multiline", false) {
      if #available(iOS 14.0, *) {
        return AnyView(TextEditor(text: binding))
      }
    }
    #endif

    let placeholder = props.string("placeholder", "")
    let padding = props.cgFloat("padding", 0.0)

    return AnyView(
      TextField(
        placeholder,
        text: binding,
        onEditingChanged: onEditingChanged,
        onCommit: onCommit
      )
      .padding(padding)
    )
  }

  func render(props: RSUIProps) -> some View {
    let color = props.color("color", .black)
    
    return renderTextField()
      .foregroundColor(color)
      .font(.system(size: 14))
  }
}
