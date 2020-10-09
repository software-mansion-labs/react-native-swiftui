
public class RSUILayoutMetrics: CustomStringConvertible {
  var x: CGFloat = 0
  var y: CGFloat = 0
  var width: CGFloat = 0
  var height: CGFloat = 0

  init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  }

  public var description: String {
    return "RSUILayoutMetrics(\(x), \(y), \(width), \(height))"
  }
}
