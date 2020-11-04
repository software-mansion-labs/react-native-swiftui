
import SwiftUI

open class RSUIBlur: RSUIView {
  public override class var viewName: String { "RSUIBlur" }

  public override func render() -> AnyView {
    return AnyView(
      Children()
        .blur(
          radius: props.cgFloat("radius", 1.0)
        )
    )
  }
}
