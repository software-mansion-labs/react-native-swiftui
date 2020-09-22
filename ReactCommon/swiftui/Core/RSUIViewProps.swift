
import SwiftUI

@objc
public class RSUIViewProps: RSUIDynamicObject {
  public let viewTag: ViewTag
  private let viewRegistry: RSUIViewRegistry

  var children: [RSUIViewWrapper] {
    return self.viewRegistry.children(forViewTag: viewTag)
  }

  required init(viewRegistry: RSUIViewRegistry, tag: ViewTag) {
    self.viewRegistry = viewRegistry
    self.viewTag = tag
  }

  // MARK: value getters

  public func color(_ key: String) -> Color {
    let colorInt = int(key)
    let ratio = 256.0
    let red = Double((colorInt >> 16) & 0xff) / ratio
    let green = Double((colorInt >> 8) & 0xff) / ratio
    let blue = Double((colorInt >> 0) & 0xff) / ratio
    let alpha = Double((colorInt >> 24) & 0xff) / ratio
    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}
