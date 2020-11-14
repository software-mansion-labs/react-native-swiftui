
public class RSUIState {
  private lazy var dict: [String: Any] = [:]

  init(_ initialValue: [String: Any]? = nil) {
    if let value = initialValue {
      dict = value
    }
  }

  subscript<T>(key: String) -> T? {
    get {
      return dict[key] as? T
    }
    set(newValue) {
      dict[key] = newValue
    }
  }

  subscript<T>(key: String, _ fallback: T) -> T {
    return dict[key] as? T ?? fallback
  }
}
