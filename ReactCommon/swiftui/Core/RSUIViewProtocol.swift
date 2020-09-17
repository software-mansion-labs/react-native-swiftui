
public protocol RSUIViewProtocol {
  associatedtype ReturnViewType

  static var viewName: String { get }

  func render(props: RSUIViewProps) -> ReturnViewType
}
