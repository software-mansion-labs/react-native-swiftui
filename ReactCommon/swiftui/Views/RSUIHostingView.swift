
import SwiftUI

struct RSUIHostingView: View {
  public static func viewName() -> String {
    return "RootView"
  }

  @ObservedObject
  public var viewRegistry: RSUIViewRegistry

  public var body: some View {
    let children = viewRegistry.childrenForRootView()
    return ForEach(children) { $0 }
  }
}
