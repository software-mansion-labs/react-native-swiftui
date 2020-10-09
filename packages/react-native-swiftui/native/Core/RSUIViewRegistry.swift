
import SwiftUI

public typealias ViewTag = Int
public typealias ViewName = String

@objc
public class RSUIViewRegistry: RSUIViewRegistryObjC, ObservableObject {
  var descriptors: [ViewTag: RSUIViewDescriptor] = [:]
  var viewTypes: [ViewName: RSUIView.Type] = [:]
  let factory: RSUIComponentViewFactory

  // MARK: public

  @objc
  public override init() {
    factory = RSUIComponentViewFactory.standard()
    super.init()

    register(viewType: RSUIHostingView.self)
    register(viewType: RSUIView.self)
    register(viewType: RSUITextView.self)
    register(viewType: RSUIRawTextView.self)
    register(viewType: RSUIButton.self)
    register(viewType: RSUITextInput.self)
    register(viewType: RSUISwitchView.self)
    register(viewType: RSUIShadow.self)
    register(viewType: RSUIMask.self)
    register(viewType: RSUIRect.self)
    register(viewType: RSUICircle.self)
  }

  @objc
  public func viewDescriptor(forTag tag: ViewTag) -> RSUIViewDescriptor? {
    return descriptors[tag]
  }

  // MARK: View management

  @objc
  @discardableResult
  public func create(_ tag: ViewTag, name: ViewName) -> RSUIViewDescriptor? {
    if let viewType = viewTypes[name] {
      descriptors[tag] = RSUIViewDescriptor(
        tag: tag,
        name: name,
        viewType: viewType,
        viewRegistry: self
      )
    }
    return viewDescriptor(forTag: tag)
  }

  @objc
  public func insert(_ tag: ViewTag, toParent parentTag: ViewTag, atIndex index: Int) {
    if let descriptor = descriptors[parentTag], index <= descriptor.children.count {
      descriptor.insertChild(tag, atIndex: index)
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

  subscript(key: ViewTag) -> RSUIViewDescriptor? {
    return viewDescriptor(forTag: key)
  }

  // MARK: internal

  internal func register(viewType: RSUIView.Type, name: String? = nil) {
    let name = name ?? viewType.viewName
    viewTypes[name] = viewType.self
  }
}
