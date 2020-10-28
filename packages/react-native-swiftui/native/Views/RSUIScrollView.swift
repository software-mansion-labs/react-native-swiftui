
import SwiftUI

open class RSUIScrollView: RSUIView {
  public override class var viewName: String { "RSUIScrollView" }

  // MARK: Commands

  public override var commands: [String: RSUICommand] {
    [
      "scrollTo": { args in
        self.setState([
          "scrollTarget": [args[0] as? Int, args[1] as? Int],
          "scrollAnimated": args[2] as? Bool ?? true,
        ])
      }
    ]
  }

  // MARK: Render

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
    let contentSize = children.reduce((width: 0, height: 0)) { size, child in
      return (
        width: max(size.width, child.layoutMetrics.x + child.layoutMetrics.width),
        height: max(size.height, child.layoutMetrics.y + child.layoutMetrics.height)
      )
    }

    let showsIndicators = props.boolean("showsIndicators", true)
    let axisSet = axes()
    let maxY = max(0, Int(contentSize.height - layoutMetrics.height))

    return AnyView(
      ScrollView(axisSet, showsIndicators: showsIndicators) {
        ScrollViewReader { [self] (scrollViewProxy: ScrollViewProxy) in
          ZStack(alignment: .topLeading) {
            // `ScrollViewProxy` doesn't provide a way to scroll to specified point within the view,
            // instead it let us scroll to a view with specified ID. To omit this limitation,
            // we render empty points filling the entire axis with an ID being its (X,Y) position.
            VStack(alignment: .leading, spacing: 0) {
              ForEach(0..<maxY) { y in
                Rectangle()
                  .fill(Color.clear)
                  .frame(width: 0, height: 1)
                  .id("0,\(y)")
              }
            }

            // Since children are positioned absolutely, we have to tell the scroll view
            // how much space its content takes.
            Rectangle()
              .fill(Color.clear)
              .frame(width: contentSize.width, height: contentSize.height)

            // Render scrolling content
            ForEach(children) { $0 }
          }
          // Use the proxy to scroll to given position once the target changes.
          .onChange(of: state["scrollTarget"] as [Int?]?) { target in
            guard let target = target else {
              // Target is unset — no reason to do anything.
              return
            }
            let scrollToClosure = {
              // Scrolling horizontally is not supported.
              // It would be a significant performance hit in the current implementation.
//              if let x = target[0] {
//                scrollViewProxy.scrollTo("\(x),0", anchor: .leading)
//              }
              if let y = target[1] {
                scrollViewProxy.scrollTo("0,\(min(y, maxY - 1))", anchor: .top)
              }
            }

            if state["scrollAnimated", true] {
              withAnimation { scrollToClosure() }
            } else {
              scrollToClosure()
            }

            // Reset scroll target until next `scrollTo` call.
            setState([
              "scrollTarget": nil,
              "scrollAnimated": nil,
            ])
          }
        }
      }
      .edgesIgnoringSafeArea(.all)
    )
  }
}
