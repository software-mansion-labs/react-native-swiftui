
import SwiftUI

extension View {
  @ViewBuilder
  func `if`<T: View>(_ condition: @autoclosure () -> Bool, _ apply: (Self) -> T) -> some View {
    if condition() {
      apply(self)
    } else {
      self
    }
  }
}
