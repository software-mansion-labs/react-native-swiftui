
import SwiftUI

public struct Children: View {
  @ObservedObject
  var parentDescriptor: RSUIViewDescriptor

  init(_ parent: RSUIAnyView) {
    self.parentDescriptor = parent.descriptor
  }

  public var body: some View {
    return ForEach(parentDescriptor.getChildren()) { $0 }
  }
}
