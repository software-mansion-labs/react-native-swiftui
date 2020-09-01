
import SwiftUI

@objc(RSUIComponentView)
open class RSUIComponentView: RSUIComponentViewObjC {

  lazy var hostingController: UIHostingController<AnyView> = {
    let contentView = RSUIView()
    return UIHostingController(rootView: AnyView(contentView.environmentObject(props)))
  }()

  var props: RSUIViewProps = RSUIViewProps()

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /**
   * Once the view is moved to its superview we can initialize a `UIHostingController`
   * and attach it to parent view controller.
   */
  open override func didMoveToSuperview() {
    if let parentViewController = parentViewController() {
      hostingController.view.backgroundColor = .clear

      parentViewController.addChild(hostingController)
      addSubview(hostingController.view)
      hostingController.didMove(toParent: parentViewController)
    }
  }

  open override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview == nil && superview != newSuperview {
      hostingController.removeFromParent()
      hostingController.view.removeFromSuperview()
      hostingController.didMove(toParent: nil)
    }
  }

  open override func layoutSubviews() {
    hostingController.view.frame.size = frame.size
  }

  // MARK: RSUIComponentViewProtocol

  open override func updateProps(_ propsDict: [AnyHashable : Any]!) {
    if let text = propsDict["text"] as? String {
      props.text = text
    }
    if let backgroundColor = propsDict["backgroundColor"] as? String {
      props.backgroundColor = backgroundColor
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
}
