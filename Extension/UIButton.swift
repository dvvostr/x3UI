import UIKit

// MARK: - UIButton

extension UIButton {
    public func setImage(_ image: UIImage?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setImage(image, for: state)
        }
    }
    public func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
    }
}
