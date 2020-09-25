
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

  public func render() -> AnyView {
    return AnyView(
      FlexContainer {
        Children(props.children)
      }
      .onTapGesture {
        self.eventEmitter.dispatchEvent("tap")
      }
      .onLongPressGesture {
        self.eventEmitter.dispatchEvent("longPress")
      }
    )
  }

  internal func update() {
    descriptor.commitUpdates()
  }

  // MARK: View helpers

  func Children(_ children: [RSUIViewWrapper]) -> some View {
    return ZStack(alignment: .topLeading) {
      ForEach(children) { $0 }
    }
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
