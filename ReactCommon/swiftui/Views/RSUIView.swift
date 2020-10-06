
import SwiftUI

open class RSUIView: RSUIViewProtocol {
  public class var viewName: String { "View" }

  public class func traits() -> RSUIViewTraits { [.Layoutable, .Styleable] }

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
    return AnyView(
      ZStack(alignment: .topLeading) {
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

  func AlignHorizontally<Content: View>(alignment: HorizontalAlignment, content: () -> Content) -> AnyView {
    switch alignment {
    case .leading:
      return AnyView(HStack { content(); Spacer() })
    case .center:
      return AnyView(HStack { Spacer(); content(); Spacer() })
    case .trailing:
      return AnyView(HStack { Spacer(); content() })
    default:
      return AnyView(HStack { content() })
    }
  }

  func AlignVertically<Content: View>(alignment: VerticalAlignment, content: () -> Content) -> AnyView {
    switch alignment {
    case .top:
      return AnyView(VStack { content(); Spacer() })
    case .center:
      return AnyView(VStack { Spacer(); content(); Spacer() })
    case .bottom:
      return AnyView(VStack { Spacer(); content() })
    default:
      return AnyView(VStack { content() })
    }
  }

  func AlignContainer<Content: View>(alignment: Alignment, content: () -> Content) -> AnyView {
    return AnyView(AlignHorizontally(alignment: alignment.horizontal) {
      AlignVertically(alignment: alignment.vertical, content: content)
    })
  }
}
