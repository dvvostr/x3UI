import UIKit
import x3Core

public enum UIX3AlertViewSize {
    case fixed, percent
}

public enum UIX3CustomAlertButton: CaseIterable {
    case ok, cancel, help
}

public enum UIX3CustomAlertButtonType: Int {
    case none = 0
    case ok = 1
    case cancel = 2
    case help = 3
}
public struct UIX3CustomAlertButtonOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let ok = UIX3CustomAlertButtonOptions(rawValue: 1 << 0)
    public static let cancel = UIX3CustomAlertButtonOptions(rawValue: 1 << 1)
    public static let help = UIX3CustomAlertButtonOptions(rawValue: 1 << 2)

    public static let `default`: UIX3CustomAlertButtonOptions = [.cancel, .ok]
    public static let all: UIX3CustomAlertButtonOptions = [.help, .cancel, .ok]
    
    public var count: Int {
        get {
            var _value: Int = 0
            _value += self.contains(.ok) ? 1 : 0
            _value += self.contains(.cancel) ? 1 : 0
            _value += self.contains(.help) ? 1 : 0
            return _value
        }
    }
    func elements() -> AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            return AnyIterator {
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                return nil
            }
        }
    }
    static func getAlertButtonType(_ value: UIX3CustomAlertButtonOptions) -> UIX3CustomAlertButtonType {
        switch value {
        case .ok: return .ok
        case .cancel: return .cancel
        case .help: return .help
        default: return .none
        }
    }
}
@objc public protocol UIX3CustomAlertViewControllerDelegate {
    @objc optional func alertView(sender: UIX3CustomAlertViewController, buttonType: Int, buttonCreate: UX3CustomButton?)
    @objc optional func alertView(sender: UIX3CustomAlertViewController, buttonClickType: Int)
}

@IBDesignable open class UIX3CustomAlertViewController: UIViewController {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
    public struct Defaults {
        public struct AlertView {
            public struct Color {
                public static var background: UIColor? = UIX3CustomControl.Defaults.Color.background
                public static var message: UIColor? = UIX3CustomControl.Defaults.Color.text
                public static var caption: UIColor? = UIX3CustomControl.Defaults.Color.text
            }
            public struct Buttons {
                public static var spacing: CGFloat = 12.0
                public static var height: CGFloat = 38
            }
            public static var height: CGFloat = 12.0
            public static var width: CGFloat = 280.0
            public static var padding: CGFloat = 12.0
        }
        public struct Color {
            public static var background: UIColor? = UIColor.systemFill.withAlphaComponent(0.3)
        }
        public static var duration: CGFloat = 0.3
        public static var showAnimation: Int = 0
    }
// MARK: ************ Initialize & invalidate ************
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupView()
        self.setupWindow()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func setupView() {
        self.setupWindow()
        self.window?.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.bgView!, at: 0)
        self.bgView?.fillSuperview()
        self.bgView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleBackgroundViewClick)))
        self.view.addSubview(alertView!)
        self.invalidateButtonView()
        self.invalidate()
    }
    func setupWindow() {
        if isNotReady { return }
        
        self.parentWindow = UIApplication.keyWindow
        if let _scene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene  {
            self.window = UIWindow(windowScene: _scene)
        } else {
            self.window = UIWindow(frame: (UIApplication.keyWindow?.bounds)!)
        }
        self.window?.frame = UIScreen.main.bounds
        self.window?.backgroundColor = .clear
        self.window?.windowLevel = UIWindow.Level.alert
        self.window?.rootViewController = self
    }
    var isNotReady: Bool {
        get {
            return UIApplication.keyWindow == nil
        }
    }
    open func invalidate() {
        let _padding: CGFloat = UIX3CustomAlertViewController.Defaults.AlertView.padding,
            _height: CGFloat = self.alertSize == .fixed ? _padding : self.view.bounds.height * (self.alertHeight / 100),
            _width: CGFloat = self.alertSize == .fixed ? self.alertWidth : self.alertWidth > 90 ? self.view.bounds.width * 0.9 : self.view.bounds.width * (self.alertWidth / 100)
        var _: CGFloat = 0.0
        
        self.alertView?.layer.borderColor = self.borderColor?.cgColor ?? UIColor.clear.cgColor
        self.alertView?.layer.borderWidth = self.borderWidth
        self.alertView?.layer.cornerRadius = self.cornerRadius

        self.bgView?.frame = self.view.bounds
        let _rect = CGRect(
            x: self.view.bounds.width / 2 - (_width / 2),
            y: self.view.bounds.height / 2 - (_height / 2),
            width: _width,
            height: _height
        )
        self.alertView?.frame = _rect
    }
    open func invalidateButtonView() {}

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    deinit {
    }
// #MARK: ******* Handles *******
    @objc private func handleBackgroundViewClick() {
        self.hide()
    }
    @objc private func handleButtonClick(sender: Any?) {
        guard let _btn = sender as? UX3CustomButton, let _buttonType = UIX3CustomAlertButtonType(rawValue: _btn.tag) else { return }
        self.buttonViewClick(_btn, buttonType: _buttonType)
    }
    open func buttonViewClick(_ sender: UX3CustomButton, buttonType: UIX3CustomAlertButtonType) {
        self.alertViewDelegate?.alertView?(sender: self, buttonClickType: buttonType.rawValue)
        switch buttonType {
        case .ok: self.buttonOKHelper == nil ? self.dismissAlertView() : self.buttonOKHelper?(self)
        case .cancel: self.buttonCancelHelper == nil ? self.dismissAlertView() : self.buttonCancelHelper?(self)
        case .help: self.buttonHelpHelper?(self)
        default: break;
        }
    }
    func createButton(_ buttonType: UIX3CustomAlertButtonType, settings: UX3CustomButtonSettings) -> UX3CustomButton {
        let _button = UX3CustomButton(frame: .zero, settings: settings)
        _button.setTitle((settings.caption ?? "").localized, for: .normal)
        _button.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing,
            bottom: 0,
            right: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing
        )
        _button.cornerRadius = settings.borderRadius
        _button.setImage(settings.image)
        _button.tag = buttonType.rawValue
        _button.addTarget(self, action: #selector(self.handleButtonClick(sender:)), for: .touchUpInside)
        self.alertViewDelegate?.alertView?(sender: self, buttonType: buttonType.rawValue, buttonCreate: _button)
        if let _font = _button.titleLabel?.font, let _str = _button.title(for: .normal) {
            _button.frame = CGRect(x: 0, y: 0, width: _str.widthOfString(usingFont: _font) + (UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing * 3), height: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.height)
        } else {
            _button.frame = CGRect(x: 0, y: 0, width: 100, height: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.height)
        }

        return _button
    }
    func getButtonSettings(_ buttonType: UIX3CustomAlertButtonType) -> UX3CustomButtonSettings {
        switch buttonType {
        case .ok: return buttonOKSettings ?? UX3CustomButton.Defaults.settings
        case .cancel: return buttonCancelSettings ?? UX3CustomButton.Defaults.settings
        case .help: return buttonHelpSettings ?? UX3CustomButton.Defaults.settings
        default: return UX3CustomButton.Defaults.settings
        }
    }
// #MARK: ******* Private propertyes *******
    private var window: UIWindow?
    private var parentWindow: UIWindow?
    private var buttons = [UIButton]()
    private lazy var bgView: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIX3CustomAlertViewController.Defaults.Color.background
        _view.isUserInteractionEnabled = true
        return _view
    }()
    open lazy var alertView: UIView? = {
        let _view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        _view.backgroundColor = UIX3CustomAlertViewController.Defaults.AlertView.Color.background
        _view.isUserInteractionEnabled = true
        return _view
    }()
// #MARK: ******* Public propertyes *******
    open var alertViewDelegate: UIX3CustomAlertViewControllerDelegate?

    open var buttonOptions: UIX3CustomAlertButtonOptions  = [.ok] {
        didSet {
            invalidateButtonView()
        }
    }

    open var buttonOKSettings: UX3CustomButtonSettings? = UIX3AlertViewController.Defaults.AlertView.buttonOKSettings {
        didSet {
            self.invalidateButtonView()
            self.invalidate()
        }
    }
    open var buttonCancelSettings: UX3CustomButtonSettings? = UIX3AlertViewController.Defaults.AlertView.buttonCancelSettings {
        didSet {
            self.invalidateButtonView()
            self.invalidate()
        }
    }
    open var buttonHelpSettings: UX3CustomButtonSettings? = UIX3AlertViewController.Defaults.AlertView.buttonHelpSettings {
        didSet {
            self.invalidateButtonView()
            self.invalidate()
        }
    }
    open var buttonOKHelper: ObjectEvent? = nil
    open var buttonCancelHelper: ObjectEvent? = nil
    open var buttonHelpHelper: ObjectEvent? = nil {
        didSet { self.invalidate() }
    }


    open var borderWidth: CGFloat = UIX3CustomControl.Defaults.borderWidth
    open var borderColor: UIColor? = UIX3CustomControl.Defaults.Color.border
    open var cornerRadius: CGFloat = UIX3CustomControl.Defaults.cornerRadius
    open var alertHeight: CGFloat = UIX3CustomAlertViewController.Defaults.AlertView.height {
        didSet { self.invalidate() }
    }
    open var alertWidth: CGFloat = UIX3CustomAlertViewController.Defaults.AlertView.width {
        didSet { self.invalidate() }
    }
    open var alertSize: UIX3AlertViewSize = .fixed {
        didSet { self.invalidate() }
    }
// #MARK: ******* Public methods *******
    open func show() {
        if UIX3CustomAlertViewController.Defaults.duration < 0.1 {
            UIX3CustomAlertViewController.Defaults.duration = 0.3
        }
        showWithDuration(Double(UIX3CustomAlertViewController.Defaults.duration))
    }
    open func hide() {
        if UIX3CustomAlertViewController.Defaults.duration < 0.1 {
            UIX3CustomAlertViewController.Defaults.duration = 0.3
        }
        dismissWithDuration(Double(UIX3CustomAlertViewController.Defaults.duration))
    }
    @objc open func dismissAlertView() {
        if UIX3CustomAlertViewController.Defaults.duration < 0.1 {
            UIX3CustomAlertViewController.Defaults.duration = 0.3
        }
        dismissWithDuration(0.3)
    }
    
    open func showWithDuration(_ duration: Double) {
        if isNotReady || self.window == nil { return }
        self.window?.makeKeyAndVisible()
        self.view.alpha = 0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.alpha = 1
        })
    }
    
    private func dismissCompletion() {
        self.parentWindow?.makeKeyAndVisible()
//        self.window?.isHidden = true
        self.window = nil
        self.parentWindow = nil
    }
    open func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete { self.dismissCompletion() }
        }
        
        self.alertView?.alpha = 1
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.alpha = 0
        }, completion: completion)
    }
}
