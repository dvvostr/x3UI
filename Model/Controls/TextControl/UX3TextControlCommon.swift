public enum UX3TextControlButtonType {
    case none, button, icon, clear
}
@objc public protocol UX3TextControlDelegate {
    @objc optional func UX3TextControlTextChange(_ sender: Any?)
    @objc optional func UX3TextControlRightButtonClick(_ sender: Any?)
    @objc optional func UX3TextControlLeftButtonClick(_ sender: Any?)
}
