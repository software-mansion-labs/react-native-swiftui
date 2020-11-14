
import SwiftUI

final class RSUITextView: RSUIView {
  static var name: String { "Paragraph" }

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

  func toFontWeight(_ fontWeight: String?) -> Font.Weight {
    switch fontWeight {
    case "100":
      return .ultraLight
    case "200":
      return .thin
    case "300":
      return .light
    case "400", "normal":
      return .regular
    case "500":
      return .medium
    case "600":
      return .semibold
    case "700", "bold":
      return .bold
    case "800":
      return .heavy
    case "900":
      return .black
    default:
      return .regular
    }
  }

  func render(props: RSUIProps) -> some View {
    let numberOfLines = props.int("numberOfLines", -1)
    let ellipsizeMode = props.string("ellipsizeMode")
    let attributedString = shadowNodeState.dictionary("attributedString") ?? [:]
    let fragments = attributedString["fragments"] as! Array<Dictionary<String, Any>>
    let textAlign = props.alignment("textAlign", .leading).horizontal

    return AlignHorizontally(alignment: textAlign) {
      ForEach((0..<fragments.count)) { [self] fragmentIndex in
        let fragment = fragments[fragmentIndex]
        let text = fragment["string"] as! String
        let attributes = fragment["textAttributes"] as! Dictionary<String, Any>

        Text(text)
          .font(
            .system(
              size: attributes["fontSize"] as! CGFloat,
              weight: toFontWeight(attributes["fontWeight"] as? String)
            )
          )
          .if(attributes["fontStyle"] as? String == "italic") { $0.italic() }
          .lineLimit(numberOfLines >= 0 ? numberOfLines : nil)
          .truncationMode(ellipsizeModeToTruncationMode(ellipsizeMode))
          .multilineTextAlignment(horizontalAlignmentToTextAlignment(textAlign))
      }
    }
  }
}
