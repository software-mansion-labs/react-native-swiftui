
import SwiftUI

extension View {
  func FlexContainer<ContentType: View>(content: () -> ContentType) -> some View {
    ZStack(alignment: .topLeading) {
      content()
      HStack(alignment: .top) {
        VStack(alignment: .leading) {
          Spacer()
        }
        Spacer()
      }
    }
  }
}

struct RSUIHostingView: View {
  public static func viewName() -> String {
    return "RootView"
  }

  @ObservedObject
  public var viewRegistry: RSUIViewRegistry

  public var body: some View {
    let children = viewRegistry.childrenForRootView()
    let _ = print("Rendering RSUIHostingView with children count: \(children.count)")

    return FlexContainer {
      ZStack(alignment: .topLeading) {
        if children.count == 0 {
          EmptyView()
        } else {
          ForEach(children) { $0 }
        }
      }
      .background(Color.secondary)
    }
  }
}
