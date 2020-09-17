
import SwiftUI

open class RSUITextView: RSUIView {
  public override class var viewName: String { "Paragraph" }

  public override func render(props: RSUIViewProps) -> AnyView {
    let children = props.children

    return AnyView(ForEach(children) { child in
      Text(child.descriptor.props.string("text") ?? "")
        .font(.largeTitle)
        .padding(10)
    })
  }
}
