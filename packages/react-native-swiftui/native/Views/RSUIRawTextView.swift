
import SwiftUI

// Just mock this view, so we can register it. RawText shadow node
// can only be a child of Paragraph node which doesn't render its children.
open class RSUIRawTextView: RSUIView {
  public override class var viewName: String { "RawText" }

  public func render() -> some View { EmptyView() }
}
