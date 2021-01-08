
import SwiftUI

public enum RSUIViewTrait {
  case Layoutable
  case Styleable
}

public typealias RSUICommand = ([AnyObject]) -> Void

public typealias RSUIViewTraits = [RSUIViewTrait]

/**
 * The primitive representation of the view that is devoid of any associated types
 * so we can refer to view types without knowing their generics. Kind of wise type erasure.
 *
 */
public protocol RSUIAnyView: class {
  /**
   * Name of this view type that is used by the view registry as an identifier.
   * It's also used as an export name on JavaScript side.
   * Defaults to the class name (see extension below).
   */
  static var name: String { get }

  static func traits() -> RSUIViewTraits

  var descriptor: RSUIViewDescriptor { get }

  var commands: [String: RSUICommand] { get }

  init()

  /**
   * Lifecycle method that gets called each time the view receives new props.
   */
  func propsWillChange(newProps: RSUIProps)

  /**
   * Lifecycle method that gets called once the descriptor owning this view is deleted from the registry.
   * Use this method if the view requires some cleanups before it deallocates.
   */
  func viewWillDestroy()

  /**
   * Should return a result of `render(props:)` (see `RSUIView` protocol) wrapped with `AnyView`.
   */
  func renderAny(props: RSUIProps) -> AnyView
}

/**
 * Adds stubs to the protocol so concrete classes don't have to reimplement them if not needed.
 */
extension RSUIAnyView {
  static var name: String {
    return String(describing: self)
  }

  static func traits() -> RSUIViewTraits {
    return [.Layoutable, .Styleable]
  }

  // Protocol extensions cannot have stored properties, so we do a small hack here
  // so that view classes don't have to specify the property nor the initializer.
  // We also don't want the view to keep any strong references to the descriptor - it'd result in a cycle.
  var descriptor: RSUIViewDescriptor {
    // Forcing non-optional type — if there is no descriptor for the view then
    // something went really wrong as the descriptor is an owner of the view.
    return RSUIViewRegistry.descriptorForView(self)!
  }

  // MARK: Computed properties for easier access to descriptor properties

  var props: RSUIProps { descriptor.props }
  var state: RSUIState { descriptor.state }
  var shadowNodeState: RSUIProps { descriptor.shadowNodeState }
  var eventEmitter: RSUIEventEmitter { descriptor.eventEmitter }
  var layoutMetrics: RSUILayoutMetrics { descriptor.layoutMetrics }

  // MARK: Stubs

  var commands: [String: RSUICommand] { [:] }

  func propsWillChange(newProps: RSUIProps) {}

  func viewWillDestroy() {}

  // MARK: State

  func setState(_ updater: (inout RSUIState) -> Void) {
    updater(&descriptor.state)
    descriptor.commitUpdates()
  }

  func setState(_ key: String, value: Any?) {
    setState { $0[key] = value }
  }

  func setState(_ patch: [String: Any?]) {
    setState {
      for (key, value) in patch {
        $0[key] = value
      }
    }
  }
}
