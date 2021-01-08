
import SwiftUI
import Combine

#if !os(iOS)
// `NSImage` is an equivalent of `UIImage`.
typealias UIImage = NSImage
#endif

class ImageLoader {
  func load(source: String, onResponse: @escaping (Data?) -> Void) {
    guard let url = URL(string: source) else {
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        onResponse(data)
      }
    }
    task.resume()
  }
}

final class RSUIImage: RSUIView {
  let loader = ImageLoader()

  func propsWillChange(newProps: RSUIProps) {
    let sources = newProps.array("source", [])
    let firstSource = sources.first as? [String: Any]

    if let uri = firstSource?["uri"] as? String {
      loader.load(source: uri) { data in
        if let data = data {
          self.setState("image", value: UIImage(data: data))
        }
      }
    }
  }

  /**
   * In non-UIKit OS'es we typealiased `UIImage` to `NSImage`,
   * but we still have to use different view constructor.
   */
  func renderBaseImage(_ image: UIImage) -> Image {
    #if os(iOS)
    return Image(uiImage: image)
    #else
    return Image(nsImage: image)
    #endif
  }

  func render(props: RSUIProps) -> some View {
    if let image: UIImage = state["image"] {
      return AnyView(
        renderBaseImage(image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      )
    }
    return AnyView(EmptyView())
  }
}
