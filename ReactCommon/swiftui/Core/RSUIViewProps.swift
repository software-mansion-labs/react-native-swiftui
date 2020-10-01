
import SwiftUI

@objc
public class RSUIViewProps: RSUIDynamicObject {

  public func string(_ key: String, _ fallback: String) -> String {
    return string(key) ?? fallback
  }

  public func color(_ key: String, _ fallback: Color) -> Color {
    let colorInt = int(key, -1)

    guard colorInt > 0 else {
      return fallback
    }

    let ratio = 256.0
    let red = Double((colorInt >> 16) & 0xff) / ratio
    let green = Double((colorInt >> 8) & 0xff) / ratio
    let blue = Double((colorInt >> 0) & 0xff) / ratio
    let alpha = Double((colorInt >> 24) & 0xff) / ratio
    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}
