import UIKit

/********************************************************/
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let _tabc = controller as? UITabBarController {
            if let selected = _tabc.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let _vc = controller?.presentedViewController {
            return topViewController(controller: _vc)
        }
        return controller
    }
    class func getTopViewController() -> UIViewController? {
        var viewController = UIViewController()
        if let vc =  self.shared.delegate?.window??.rootViewController {
            viewController = vc
            var presented = vc
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        return viewController
    }
    public class var topViewController: UIViewController? {
        get{
            return UIApplication.getTopViewController()
        }
    }
    public class var statusBar: UIView? {
        get {
            return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        }
    }
    public class var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first ?? UIApplication.shared.windows.first
        }
    }
}
/********************************************************/
// #MARK: UIApplication Extension
extension UIApplication {
    public var statusBarUIView: UIView? {
        #if canImport(SwiftUI) // XCode 11.x *
        if #available(iOS 13.0, *) {
            let tag = 38482
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let keyWindow = UIApplication.keyWindow else { return nil}

            if let statusBar = keyWindow.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.alpha = 0
                statusBarView.tag = tag
                keyWindow.addSubview(statusBarView)
                UIView.animate(withDuration: 0.5, animations: {
                    statusBarView.alpha = 1
                })
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
        #else
            return value(forKey: "statusBar") as? UIView
        #endif
    }
    public static var orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation ?? .unknown
        }
    }
    public static var firstWindow: UIWindow? {
        get {
            return UIApplication.shared.windows.first
        }
    }
}
