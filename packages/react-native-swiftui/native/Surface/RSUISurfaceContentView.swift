
import SwiftUI

#if canImport(UIKit)
public typealias BaseView = UIView
#else
public typealias BaseView = NSView
#endif

@objc
public class RSUISurfaceContentView: BaseView {
  var surfaceDescriptor: RSUIViewDescriptor?

#if canImport(UIKit)
  lazy var hostingController = UIHostingController(rootView: AnyView(createHostingRootView()))
#else
  lazy var hostingController = NSHostingController(rootView: AnyView(createHostingRootView()))
#endif

  @objc
  public init(viewRegistry: RSUIViewRegistry, surfaceTag: ViewTag) {
    super.init(frame: .zero)
    self.surfaceDescriptor = viewRegistry.create(surfaceTag, name: "RootView")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /**
   * Once the view is moved to its superview we can initialize a `UIHostingController`
   * and attach it to parent view controller.
   */
  #if canImport(UIKit)
  open override func didMoveToSuperview() {
    if let parentViewController = parentViewController() {
      hostingController.view.backgroundColor = .clear
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false

      parentViewController.addChild(hostingController)
      addSubview(hostingController.view)
      hostingController.didMove(toParent: parentViewController)

      NSLayoutConstraint.activate([
        hostingController.view.widthAnchor.constraint(equalTo: self.widthAnchor),
        hostingController.view.heightAnchor.constraint(equalTo: self.heightAnchor),
        hostingController.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        hostingController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
    }
  }
  #else
  open override func viewDidMoveToSuperview() {
    if let parentViewController = parentViewController() {
      hostingController.view.layer?.backgroundColor = CGColor.clear
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false

      parentViewController.addChild(hostingController)
      addSubview(hostingController.view)
//      hostingController.didMove(toParent: parentViewController)

      NSLayoutConstraint.activate([
        hostingController.view.widthAnchor.constraint(equalTo: self.widthAnchor),
        hostingController.view.heightAnchor.constraint(equalTo: self.heightAnchor),
        hostingController.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        hostingController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
    }
  }
  #endif

  #if canImport(UIKit)
  open override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview == nil && superview != newSuperview {
      hostingController.removeFromParent()
      hostingController.view.removeFromSuperview()
      hostingController.didMove(toParent: nil)
    }
  }
  #else
  open override func viewWillMove(toSuperview newSuperview: NSView?) {
    if newSuperview == nil && superview != newSuperview {
      hostingController.removeFromParent()
      hostingController.view.removeFromSuperview()
//      hostingController.didMove(toParent: nil)
    }
  }
  #endif

  // MARK: private

  /**
   * `UIHostingController` needs to be attached to another view controller
   * so we need to look up for it in responders chain.
   */
  private func parentViewController() -> UIViewController? {
    #if canImport(UIKit)
    var responder: UIResponder = self
    #else
    var responder: NSResponder = self
    #endif

    while !responder.isKind(of: UIViewController.self) {
      #if canImport(UIKit)
      let next = responder.next
      #else
      let next = responder.nextResponder
      #endif

      if let next = next {
        responder = next
      } else {
        break
      }
    }

    #if canImport(UIKit)
    return responder as? UIViewController
    #else
    return responder as? NSViewController
    #endif
  }

  private func createHostingRootView() -> some View {
    return RSUIViewWrapper(descriptor: surfaceDescriptor!)
      .edgesIgnoringSafeArea(.all)
  }
}
