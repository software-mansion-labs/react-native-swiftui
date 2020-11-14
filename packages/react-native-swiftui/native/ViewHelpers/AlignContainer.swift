
import SwiftUI

struct AlignContainer<Content: View>: View {
  var alignment: Alignment
  var content: () -> Content

  var body: some View {
    return AlignHorizontally(alignment: alignment.horizontal) {
      AlignVertically(alignment: alignment.vertical, content: content)
    }
  }
}
