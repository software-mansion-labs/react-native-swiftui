
import SwiftUI

open class RSUITextView: RSUIView {
  public typealias RenderReturnType = ForEach

  public override class var viewName: String { "Paragraph" }

  func ellipsizeModeToTruncationMode(_ ellipsizeMode: String?) -> Text.TruncationMode {
    // TODO: Add support for "clip".
    switch ellipsizeMode {
    case "head":
      return .head
    case "middle":
      return .middle
    default:
      return .tail
    }
  }

  func horizontalAlignmentToTextAlignment(_ horizontalAlignment: HorizontalAlignment) -> TextAlignment {
    // One of the dummiest conversions I've seen 🙈
    switch horizontalAlignment {
    case .leading:
      return .leading
    case .center:
      return .center
    case .trailing:
      return .trailing
    default:
      return .leading
    }
  }

  public override func render() -> AnyView {
    let numberOfLines = props.int("numberOfLines", -1)
    let ellipsizeMode = props.string("ellipsizeMode")
    let attributedString = shadowNodeState.dictionary("attributedString") ?? [:]
    let fragments = attributedString["fragments"] as! Array<Dictionary<String, Any>>
    let textAlign = props.alignment("textAlign", .leading).horizontal

    return AnyView(
      AlignHorizontally(alignment: textAlign) {
        ForEach((0..<fragments.count)) { [self] fragmentIndex in
          let fragment = fragments[fragmentIndex]
          let text = fragment["string"] as! String
          let attributes = fragment["textAttributes"] as! Dictionary<String, Any>
          let fontSize = attributes["fontSize"] as! CGFloat

          Text(text)
            .font(.system(size: fontSize))
            .lineLimit(numberOfLines >= 0 ? numberOfLines : nil)
            .truncationMode(ellipsizeModeToTruncationMode(ellipsizeMode))
            .multilineTextAlignment(horizontalAlignmentToTextAlignment(textAlign))
        }
      }
    )
  }
}
