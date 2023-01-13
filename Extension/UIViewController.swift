import UIKit
 
extension UIViewController {
    @objc open class func fromNib() -> Self {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            return T(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        }
        return instantiateFromNib(self)
    }
}
public extension UIViewController {
     @objc func showAlert(title: String = "Error", message: String = "", buttonTitle: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        let _vc = UIAlertController(
            title: title.localized,
            message: message.localized,
            preferredStyle: .alert
        )
        _vc.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        present(_vc, animated: true, completion: nil)
    }
 
    @objc func showYesNoAlert(title: String = "", message: String = "", yesTitle: String = "Yes", noTitle: String = "No", yesHandler: ((UIAlertAction) -> Void)? = nil, noHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: yesTitle, style: .default, handler: yesHandler))
        alertController.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: noHandler))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAlertWithTextField(title: String, message: String, textFieldConfiguration: ((UITextField) -> Void)? = nil, confirmButtonTitle: String = "ОК", handler: @escaping (UIAlertController?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textFieldConfiguration?(textField)
        }
        alert.addAction(UIAlertAction(title: confirmButtonTitle, style: .default, handler: { [weak alert] _ in
            handler(alert)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @objc func showPopover(_ viewController: UIViewController, sourceRect: CGRect, with size: CGSize, direction: UIPopoverArrowDirection = .up) {
        viewController.modalPresentationStyle = .popover
        let popoverPresentation: UIPopoverPresentationController? = viewController.popoverPresentationController
        popoverPresentation?.sourceView = view
        popoverPresentation?.permittedArrowDirections = direction
        popoverPresentation?.sourceRect = sourceRect
        viewController.preferredContentSize = size
        present(viewController, animated: true)
    }
    
    @objc func showPopover(_ viewController: UIViewController, barButton: UIBarButtonItem, with size: CGSize, direction: UIPopoverArrowDirection = .up) {
        viewController.modalPresentationStyle = .popover
        let popoverPresentation: UIPopoverPresentationController? = viewController.popoverPresentationController
        popoverPresentation?.sourceView = view
        popoverPresentation?.permittedArrowDirections = direction
        popoverPresentation?.barButtonItem = barButton
        viewController.preferredContentSize = size
        present(viewController, animated: true)
    }
    func isModal() -> Bool {
        if self.presentingViewController != nil ||
            self.presentingViewController?.presentedViewController == self ||
            self.navigationController?.presentingViewController?.presentedViewController == self.navigationController ||
            self.tabBarController?.presentingViewController?.isKind(of: UITabBarController.self) != nil {
            return true
        }
        
        return false
    }
}
