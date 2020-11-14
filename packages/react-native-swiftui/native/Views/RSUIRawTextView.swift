
import SwiftUI

// Just mock this view, so we can register it. RawText shadow node
// can only be a child of Paragraph node which doesn't render its children.
final class RSUIRawTextView: RSUIView {
  static var name: String { "RawText" }

  func render(props: RSUIProps) -> some View { EmptyView() }
}
