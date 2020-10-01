
@objc
public class RSUIViewDescriptor: NSObject, ObservableObject {
  let tag: ViewTag
  let name: ViewName
  let viewType: RSUIView.Type
  let viewRegistry: RSUIViewRegistry

  lazy var view: RSUIView = viewType.init(self)

  @objc
  public var props: RSUIViewProps {
    willSet {
      view.propsWillChange(newProps: newValue)
    }
  }

  @objc
  public let state: RSUIViewProps

  @objc
  public let eventEmitter: RSUIEventEmitter

  // Is SwiftUI layout engine broken? If initial width or height
  // multiplied by device's scale factor is less than 0.5
  // then further changes are being ignored 🤯
  var layoutMetrics = RSUILayoutMetrics(x: 1, y: 1, width: 0.167, height: 0.167)

  var children: [ViewTag] = []

  @Published
  var revision: UInt = 0

  init(tag: ViewTag, name: ViewName, viewType: RSUIView.Type, viewRegistry: RSUIViewRegistry) {
    self.tag = tag
    self.name = name
    self.viewType = viewType
    self.viewRegistry = viewRegistry
    self.props = RSUIViewProps()
    self.state = RSUIViewProps()
    self.eventEmitter = RSUIEventEmitter()
    super.init()
  }

  func createView() -> RSUIViewWrapper {
    return RSUIViewWrapper(descriptor: self)
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
  public func updateLayoutMetrics(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
    layoutMetrics.x = x
    layoutMetrics.y = y
    layoutMetrics.width = width
    layoutMetrics.height = height
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
