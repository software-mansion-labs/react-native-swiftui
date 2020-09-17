
import SwiftUI

@objc
public class RSUISurfaceContentView: UIView {
  var viewRegistry: RSUIViewRegistry?

  lazy var hostingController = UIHostingController(rootView: AnyView(createHostingRootView()))

  @objc
  public init(viewRegistry: RSUIViewRegistry) {
    super.init(frame: .zero)
    self.viewRegistry = viewRegistry
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /**
   * Once the view is moved to its superview we can initialize a `UIHostingController`
   * and attach it to parent view controller.
   */
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

  open override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview == nil && superview != newSuperview {
      hostingController.removeFromParent()
      hostingController.view.removeFromSuperview()
      hostingController.didMove(toParent: nil)
    }
  }

  // MARK: private

  /**
   * `UIHostingController` needs to be attached to another view controller
   * so we need to look up for it in responders chain.
   */
  private func parentViewController() -> UIViewController? {
    var responder: UIResponder = self

    while !responder.isKind(of: UIViewController.self) {
      if let next = responder.next {
        responder = next
      } else {
        break
      }
    }
    return responder as? UIViewController
  }

  private func createHostingRootView() -> some View {
    return RSUIHostingView(viewRegistry: viewRegistry!)
      .background(Color.blue)
      .edgesIgnoringSafeArea(.all)
  }
}
