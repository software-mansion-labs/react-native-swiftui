
import SwiftUI

@objc
public class RSUIEntryViewManager: RSUIEntryViewManagerObjC {
  public func render() -> some View {
    let _ = print("RSUIEntryViewWrapper render")
    let viewRegistry = rootView.viewRegistry() as! RSUIViewRegistry
    let surfaceTag = self.surfaceTag()

    return GeometryReader { geometry -> RSUIViewWrapper in
      self.rootView.surface.setMinimumSize(geometry.size, maximumSize: geometry.size)
      return RSUIViewWrapper(descriptor: viewRegistry[surfaceTag]!)
    }
  }
}
