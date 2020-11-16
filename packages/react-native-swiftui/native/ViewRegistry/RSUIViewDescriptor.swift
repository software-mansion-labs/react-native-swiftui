
@objc
public class RSUIViewDescriptor: NSObject, ObservableObject {
  let tag: ViewTag
  let name: ViewName
  let viewRegistry: RSUIViewRegistry
  let view: RSUIAnyView

  lazy var state = RSUIState()

  @objc
  public var props: RSUIProps {
    willSet {
      view.propsWillChange(newProps: newValue)
    }
  }

  @objc
  public let shadowNodeState: RSUIProps

  @objc
  public let eventEmitter: RSUIEventEmitter

  // Is SwiftUI layout engine broken? If initial width or height
  // multiplied by device's scale factor is less than 0.5
  // then further changes are being ignored 🤯
  var layoutMetrics = RSUILayoutMetrics(x: 1, y: 1, width: 0.167, height: 0.167)

  var children: [ViewTag] = []

  @Published
  var revision: UInt = 0

  init(tag: ViewTag, name: ViewName, viewType: RSUIAnyView.Type, viewRegistry: RSUIViewRegistry) {
    self.tag = tag
    self.name = name
    self.viewRegistry = viewRegistry
    self.view = viewType.init()
    self.props = RSUIProps()
    self.shadowNodeState = RSUIProps()
    self.eventEmitter = RSUIEventEmitter()
    super.init()

    // Hack that allows RSUIAnyView extension to get the descriptor.
    RSUIViewRegistry.registerView(view, forDescriptor: self)
  }

  deinit {
    // Once the descriptor is gonna be deallocated,
    // we must also unregister its view so it no longer has access to the descriptor.
    RSUIViewRegistry.unregisterView(self.view)
  }

  func createView() -> RSUIViewWrapper {
    return RSUIViewWrapper(descriptor: self)
  }

  func traits() -> RSUIViewTraits {
    let ViewType = type(of: view)
    return ViewType.traits()
  }

  // MARK: Children management

  /**
   * Inserts view with given tag as a child at specified index. Change is committed automatically.
   * TODO: Throw an exception if given view is already a child.
   */
  func insertChild(_ tag: ViewTag, atIndex index: Int) {
    if !children.contains(tag) {
      children.insert(tag, at: index)
      commitUpdates()
    }
  }

  /**
   * Removes child with given tag. Change is committed automatically.
   * TODO: Throw an exception if given view is not a child.
   */
  func removeChild(_ tag: ViewTag) {
    if let index = children.firstIndex(of: tag) {
      children.remove(at: index)
      commitUpdates()
    }
  }

  func getChildren() -> [RSUIViewWrapper] {
    return viewRegistry.children(forViewTag: tag)
  }

  // MARK: Layout management

  @objc
  public func updateLayoutMetrics(
    x: CGFloat,
    y: CGFloat,
    width: CGFloat,
    height: CGFloat,
    contentLeftInset: CGFloat,
    contentTopInset: CGFloat,
    contentRightInset: CGFloat,
    contentBottomInset: CGFloat
  ) {
    layoutMetrics = RSUILayoutMetrics(
      x: x,
      y: y,
      width: width,
      height: height,
      contentLeftInset: contentLeftInset,
      contentTopInset: contentTopInset,
      contentRightInset: contentRightInset,
      contentBottomInset: contentBottomInset
    )
  }

  // MARK: Dispatching commands

  @objc
  public func dispatchCommand(_ commandName: String, withArgs args: [AnyObject]) {
    guard let command = view.commands[commandName] else {
      // TODO: throw an exception
      return
    }
    command(args)
  }

  // MARK: Finalizing updates

  @objc
  public func commitUpdates() {
    revision += 1
  }

  // MARK: CustomStringConvertible

  public override var description: String {
    return """
\(type(of: view))(
  tag: \(tag),
  name: \(name),
  children: \(children),
  props: \(props.dictionary()),
  revision: \(revision),
)
"""
  }
}
