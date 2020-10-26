
public class RSUILayoutMetrics: CustomStringConvertible {
  var x: CGFloat = 0
  var y: CGFloat = 0
  var width: CGFloat = 0
  var height: CGFloat = 0
  var contentLeftInset: CGFloat = 0
  var contentTopInset: CGFloat = 0
  var contentRightInset: CGFloat = 0
  var contentBottomInset: CGFloat = 0

  init(
    x: CGFloat,
    y: CGFloat,
    width: CGFloat,
    height: CGFloat,
    contentLeftInset: CGFloat = 0,
    contentTopInset: CGFloat = 0,
    contentRightInset: CGFloat = 0,
    contentBottomInset: CGFloat = 0) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.contentLeftInset = contentLeftInset
    self.contentTopInset = contentTopInset
    self.contentRightInset = contentRightInset
    self.contentBottomInset = contentBottomInset
  }

  var contentFrame: CGRect {
    return CGRect(
      x: contentLeftInset,
      y: contentTopInset,
      width: width - contentLeftInset - contentRightInset,
      height: height - contentTopInset - contentBottomInset
    )
  }

  // MARK: CustomStringConvertible

  public var description: String {
    return "RSUILayoutMetrics(\(x), \(y), \(width), \(height), \(contentLeftInset), \(contentTopInset), \(contentRightInset), \(contentBottomInset))"
  }
}
