
import SwiftUI

open class RSUIScrollView: RSUIView {
  public override class var viewName: String { "RSUIScrollView" }

  func axes() -> Axis.Set {
    switch props.string("axes", "vertical") {
    case "vertical":
      return [.vertical]
    case "horizontal":
      return [.horizontal]
    case "both":
      return [.vertical, .horizontal]
    default:
      return [.vertical]
    }
  }

  public override func render() -> AnyView {
    let children = descriptor.getChildren()
    let contentSize = children.reduce(CGSize(width: 0, height: 0)) { size, child in
      return CGSize(
        width: max(size.width, child.layoutMetrics.x + child.layoutMetrics.width),
        height: max(size.height, child.layoutMetrics.y + child.layoutMetrics.height)
      )
    }

    let showsIndicators = props.boolean("showsIndicators", true)

    return AnyView(
      ScrollView(axes(), showsIndicators: showsIndicators) {
        ZStack(alignment: .topLeading) {
          // Since children are positioned absolutely, we have to tell the scroll view
          // how much space its content takes.
          Rectangle()
            .fill(Color.clear)
            .frame(width: contentSize.width, height: contentSize.height)

          // Render scrolling content
          ForEach(children) { $0 }
        }
      }
      .edgesIgnoringSafeArea(.all)
    )
  }
}
