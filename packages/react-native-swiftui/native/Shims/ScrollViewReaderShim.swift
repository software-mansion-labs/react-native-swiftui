
import SwiftUI

internal struct ScrollViewProxyShim {
  var scrollViewProxy: Any? = nil

  func scrollTo<ID>(_ id: ID, anchor: UnitPoint?) where ID: Hashable {
    #if os(iOS) // TODO: Remove this check once Xcode starts including macOS 11.0 SDK
    if #available(iOS 14.0, macOS 11.0, *) {
      (scrollViewProxy as? ScrollViewProxy)?.scrollTo(id, anchor: anchor)
    }
    #endif

    // no-op
  }
}

internal struct ScrollViewReaderShim<Content>: View where Content: View {
  public var content: (ScrollViewProxyShim) -> Content

  var body: some View {
    #if os(iOS) // TODO: Remove this check once Xcode starts including macOS 11.0 SDK
    if #available(iOS 14.0, macOS 11.0, *) {
      return AnyView(
        ScrollViewReader { scrollViewProxy in
          content(ScrollViewProxyShim(scrollViewProxy: scrollViewProxy))
        }
      )
    }
    #endif
    return AnyView(content(ScrollViewProxyShim()))
  }
}
