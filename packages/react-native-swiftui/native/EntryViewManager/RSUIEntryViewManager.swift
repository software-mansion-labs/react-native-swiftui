
import SwiftUI

@objc
public class RSUIEntryViewManager: RSUIEntryViewManagerObjC {
  public func render() -> some View {
    let _ = print("RSUIEntryViewWrapper render")
    let viewRegistry = appContext.viewRegistry() as! RSUIViewRegistry
    let surfaceTag = self.surfaceTag()
    let surfaceDescriptor = viewRegistry[surfaceTag] ?? viewRegistry.create(surfaceTag, name: "RootView")

    return GeometryReader { geometry -> RSUIViewWrapper in
      self.appContext.surface.setMinimumSize(geometry.size, maximumSize: geometry.size)
      return RSUIViewWrapper(descriptor: surfaceDescriptor!)
    }
  }
}
