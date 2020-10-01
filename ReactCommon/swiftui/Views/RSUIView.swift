
import SwiftUI

open class RSUIView: RSUIViewProtocol {
  public class var viewName: String { "View" }

  internal let descriptor: RSUIViewDescriptor

  // Computed properties for easier access to descriptor properties
  internal var props: RSUIViewProps { descriptor.props }
  internal var state: RSUIViewProps { descriptor.state }
  internal var eventEmitter: RSUIEventEmitter { descriptor.eventEmitter }

  public required init(_ descriptor: RSUIViewDescriptor) {
    self.descriptor = descriptor
  }

  /**
   * Lifecycle method that gets called each time the view receives new props.
   */
  public func propsWillChange(newProps: RSUIViewProps) {}

  public func render() -> AnyView {
    print("Rendering RSUIView \(descriptor.tag)")

    return AnyView(
      FlexContainer {
        Children()
      }
      .onTapGesture {
        self.eventEmitter.dispatchEvent("tap")
      }
      .onLongPressGesture {
        self.eventEmitter.dispatchEvent("longPress")
      }
    )
  }

  // MARK: View helpers

  func Children() -> some View {
    return ForEach(descriptor.getChildren()) { $0 }
  }

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
