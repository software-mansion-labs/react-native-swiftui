
import SwiftUI

final class RSUIMask: RSUIView {
  static var name: String { "RSUIMask" }

  func render(props: RSUIProps) -> some View {
    var children = descriptor.getChildren()
    let mask = children.count >= 2 ? children.removeFirst() : nil

    return ForEach(children) { $0 }
      .frame(width: layoutMetrics.width, height: layoutMetrics.height)
      .if(mask != nil, { $0.mask(mask) })
  }
}
