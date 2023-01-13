import UIKit

public extension UIDevice {
    static var currentOrientation: UIDeviceOrientation {
        get {
            let _device = UIDevice.current
            if _device.isGeneratingDeviceOrientationNotifications {
                _device.beginGeneratingDeviceOrientationNotifications()
                return _device.orientation
            } else {
                return .unknown
            }
        }
    }
}
