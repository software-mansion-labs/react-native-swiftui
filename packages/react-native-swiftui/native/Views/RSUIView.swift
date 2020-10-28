
import SwiftUI

open class RSUIView: RSUIViewProtocol {
  public class var viewName: String { "View" }

  public class func traits() -> RSUIViewTraits { [.Layoutable, .Styleable] }

  internal let descriptor: RSUIViewDescriptor

  // Computed properties for easier access to descriptor properties
  internal var props: RSUIViewProps { descriptor.props }
  internal var state: RSUIState { descriptor.state }
  internal var shadowNodeState: RSUIViewProps { descriptor.shadowNodeState }
  internal var eventEmitter: RSUIEventEmitter { descriptor.eventEmitter }
  internal var layoutMetrics: RSUILayoutMetrics { descriptor.layoutMetrics }

  public required init(_ descriptor: RSUIViewDescriptor) {
    self.descriptor = descriptor
  }

  public var commands: [String: RSUICommand] { [:] }

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

  // MARK: State

  public final func setState(_ updater: (inout RSUIState) -> Void) {
    updater(&descriptor.state)
    descriptor.commitUpdates()
  }

  public final func setState(_ key: String, value: Any?) {
    setState { $0[key] = value }
  }

  public final func setState(_ patch: [String: Any?]) {
    setState {
      for (key, value) in patch {
        $0[key] = value
      }
    }
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
