
import SwiftUI

public typealias ViewTag = Int
public typealias ViewName = String

@objc
public class RSUIViewDescriptor: NSObject, ObservableObject {
  let tag: ViewTag
  let name: ViewName
  let view: RSUIAnyView

  @objc
  public let props: RSUIViewProps

  // Is SwiftUI layout engine broken? If initial width or height
  // multiplied by device's scale factor is less than 0.5
  // then further changes are being ignored 🤯
  var layoutMetrics = RSUILayoutMetrics(x: 1, y: 1, width: 0.167, height: 0.167)
  var children: [ViewTag] = []

  @Published
  var revision: UInt = 0

  init(tag: ViewTag, name: ViewName, view: RSUIAnyView, props: RSUIViewProps) {
    self.tag = tag
    self.name = name
    self.view = view
    self.props = props
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
}

@objc
public class RSUIViewRegistry: NSObject, ObservableObject {
  var descriptors: [ViewTag: RSUIViewDescriptor] = [:]
  var viewTypes: [ViewName: RSUIView.Type] = [:]
  let factory: RSUIComponentViewFactory

  @Published
  var rootViewTag: ViewTag = 0

  // MARK: public

  @objc
  public override init() {
    factory = RSUIComponentViewFactory.standard()
    super.init()

    register(viewType: RSUIView.self, name: "RootView")
    register(viewType: RSUIView.self)
    register(viewType: RSUITextView.self)
    register(viewType: RSUIRawTextView.self)
  }

  @objc
  public func viewDescriptor(forTag tag: ViewTag) -> RSUIViewDescriptor? {
    return descriptors[tag]
  }

  // MARK: View management

  @objc
  public func create(_ tag: ViewTag, name: ViewName) -> RSUIViewDescriptor? {
    if let viewType = viewTypes[name] {
      let view = viewType.init()

      descriptors[tag] = RSUIViewDescriptor(
        tag: tag,
        name: name,
        view: RSUIAnyView(view.castView(to: type(of: view))),
        props: RSUIViewProps(viewRegistry: self, tag: tag)
      )
    }
    return viewDescriptor(forTag: tag)
  }

  @objc
  public func insert(_ tag: ViewTag, toParent parentTag: ViewTag, atIndex index: Int) {
    if let descriptor = descriptors[parentTag], index <= descriptor.children.count {
      descriptor.insertChild(tag, atIndex: index)
    }
    if parentTag == 1 {
      rootViewTag = parentTag
    }
  }

  @objc
  public func delete(_ tag: ViewTag) {
    descriptors.removeValue(forKey: tag)
  }

  @objc
  public func remove(_ tag: ViewTag, fromParent parentTag: ViewTag) {
    if let descriptor = descriptors[parentTag] {
      descriptor.removeChild(tag)
    }
  }

  @objc
  public func has(_ tag: ViewTag) -> Bool {
    return descriptors[tag] != nil
  }

  @objc
  public func props(forTag tag: ViewTag) -> RSUIViewProps? {
    return descriptors[tag]?.props
  }

  public func children(forViewTag tag: ViewTag) -> [RSUIViewWrapper] {
    guard let descriptor = descriptors[tag] else {
      return []
    }
    return descriptor.children
      .filter { descriptors[$0] != nil }
      .map { descriptors[$0]!.createView() }
  }

  public func childrenForRootView() -> [RSUIViewWrapper] {
    return children(forViewTag: 1)
  }

  // MARK: internal

  internal func register(viewType: RSUIView.Type, name: String? = nil) {
    let name = name ?? viewType.viewName
    viewTypes[name] = viewType.self
  }
}
