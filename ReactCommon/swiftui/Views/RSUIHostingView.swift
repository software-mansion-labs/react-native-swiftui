
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

  @State
  public var text = "d"

  public var body: some View {
    let children = viewRegistry.childrenForRootView()

    print("Hosting view render with text \(text)")

    return FlexContainer {
      ZStack(alignment: .topLeading) {
        ForEach(children) { $0 }
      }
//      .simultaneousGesture(
//        DragGesture(minimumDistance: 0, coordinateSpace: .global)
//          .onChanged { value in
//            print("drag changed", value.location, value.translation, value.startLocation)
//          }
//          .onEnded { value in
//            print("drag ended", value.location, value.translation, value.startLocation)
//          }
//        , including: .all
//      )
    }
  }
}
