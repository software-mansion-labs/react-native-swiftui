
import SwiftUI

open class RSUITextView: RSUIView {
  public typealias RenderReturnType = ForEach

  public override class var viewName: String { "Paragraph" }

  func ellipsizeModeToTruncationMode(_ ellipsizeMode: String?) -> Text.TruncationMode {
    // TODO: Add support for "clip".
    switch ellipsizeMode {
    case "head":
      return .head
    case "center":
      return .middle
    default:
      return .tail
    }
  }

  public override func render() -> AnyView {
    let numberOfLines = props.int("numberOfLines")
    let ellipsizeMode = props.string("ellipsizeMode")
    let attributedString = self.descriptor.state.dictionary("attributedString") ?? [:]
    let fragments = attributedString["fragments"] as! Array<Dictionary<String, Any>>

    return AnyView(
      ForEach((0..<fragments.count)) { [self] fragmentIndex in
        let fragment = fragments[fragmentIndex]
        let text = fragment["string"] as! String
        let attributes = fragment["textAttributes"] as! Dictionary<String, Any>
        let fontSize = attributes["fontSize"] as! CGFloat

        Text(text)
          .font(.system(size: fontSize))
          .lineLimit(numberOfLines)
          .truncationMode(ellipsizeModeToTruncationMode(ellipsizeMode))
      }
    )
  }
}
