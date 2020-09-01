
import SwiftUI

let colors: [String: Color] = [
  "black": Color.black,
  "blue": Color.blue,
  "orange": Color.orange,
  "green": Color.green,
  "pink": Color.pink,
  "yellow": Color.yellow,
  "purple": Color.purple,
  "red": Color.red,
  "transparent": Color.clear
]

class RSUIViewProps: ObservableObject {
  @Published
  var text: String = ""

  @Published
  var backgroundColor: String = "transparent"
}

struct RSUIView: View {
  @EnvironmentObject
  var props: RSUIViewProps

  @State
  var enabled: Bool = false

  var body: some View {
    Button(action: onPress) {
      ZStack {
        stringToColor(props.backgroundColor)
        Text(props.text)
      }
    }
    .alert(isPresented: $enabled) {
      Alert(title: Text("Hey, you've just pressed the button!"))
    }
  }

  // MARK: private

  private func onPress() -> Void {
    enabled = !enabled
  }

  private func stringToColor(_ colorString: String) -> Color {
    return colors[colorString] ?? Color.clear
  }
}
