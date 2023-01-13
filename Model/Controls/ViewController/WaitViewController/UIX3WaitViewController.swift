import UIKit
import x3Core


@IBDesignable open class UIX3WaitViewController: UIViewController {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
    public struct Defaults {
        public struct Color {
            public static var background: UIColor? = UIX3CustomControl.Defaults.Color.background
            public static var foreground: UIColor? = UIX3CustomControl.Defaults.Color.background
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
        self.view.addSubview(waitView!)
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
        let _padding: CGFloat = UIX3CustomAlertViewController.Defaults.AlertView.padding
            
        var _height: CGFloat = _padding,
            _width: CGFloat = _padding

        self.waitView?.layer.borderColor = self.borderColor?.cgColor ?? UIColor.clear.cgColor
        self.waitView?.layer.borderWidth = self.borderWidth
        self.waitView?.layer.cornerRadius = self.cornerRadius
        
        self.waitView?.subviews.forEach({ $0.removeFromSuperview() })
        self.waitView?.addSubview(self.activityIndicator)
        
        self.activityIndicator.frame = CGRect(
            x: _padding, // self.view.bounds.width - (_padding * 2) - (self.alertSize.width / 2),
            y: _padding,
            width: self.alertSize.width,
            height: self.alertSize.height
        )
        _height += self.alertSize.height
        _width = self.alertSize.width + (_padding * 2)

        if let _title = self.alertTitle {
            self.waitView?.addSubview(self.titleLabel)
            let _textHeight = self.titleLabel.font.lineHeight
            var _textWidth = _title.widthOfString(usingFont: self.titleLabel.font)

            if _textWidth > self.view.frame.width * 0.6 {
                _textWidth = self.view.frame.width * 0.6
            } else if _textWidth < _width - (_padding * 2) {
                _textWidth = _width - (_padding * 2)
            } else if _textWidth < _height + _textHeight + _padding {
                _textWidth = _height + _padding
            }
            self.titleLabel.frame = CGRect(
                x: _padding,
                y: _height,
                width: _textWidth,
                height: _textHeight
            )
            _width = ((_textWidth + (_padding * 2)) > _width) ? (_textWidth + (_padding * 2)) : _width
            _height += _textHeight
            self.activityIndicator.frame = CGRect(
                x: (_width / 2) - (self.activityIndicator.frame.width / 2),
                y: self.activityIndicator.frame.y,
                width: self.activityIndicator.frame.width,
                height: self.activityIndicator.frame.height)
        }
        _height += _padding

        self.bgView?.frame = self.view.bounds
        let _rect = CGRect(
            x: self.view.bounds.width / 2 - (_width / 2),
            y: self.view.bounds.height / 2 - (_height / 2),
            width: _width,
            height: _height
        )
        self.waitView?.frame = _rect
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    deinit {
    }
// #MARK: ******* Handles *******

// #MARK: ******* Private propertyes *******
    private var window: UIWindow?
    private var parentWindow: UIWindow?
    private lazy var bgView: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIX3WaitViewController.Defaults.Color.background
        _view.isUserInteractionEnabled = true
        return _view
    }()
    open lazy var waitView: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIX3WaitViewController.Defaults.Color.foreground
        return _view
    }()
    open lazy var alertView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIX3WaitViewController.Defaults.Color.foreground
        return _view
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let _view = UIActivityIndicatorView(style: .large)
        return _view
    }()
    private lazy var titleLabel: UILabel = {
        let _view = UILabel()
        _view.textAlignment = .center
        return _view
    }()

// #MARK: ******* Public propertyes *******

    open var borderWidth: CGFloat = UIX3CustomControl.Defaults.borderWidth
    open var borderColor: UIColor? = UIX3CustomControl.Defaults.Color.border
    open var cornerRadius: CGFloat = UIX3CustomControl.Defaults.cornerRadius
    open var alertSize: CGSize = CGSize(width: 100, height: 100) {
        didSet { self.invalidate() }
    }
    
    open var alertTitle: String? {
        didSet {
            self.titleLabel.text = self.alertTitle
            self.invalidate()
        }
    }
    open var alertFont: UIFont? = UIX3CustomControl.Defaults.textFont{
        didSet {
            self.titleLabel.font = self.alertFont
            self.invalidate()
        }
    }
    open var windowBackgroundColor: UIColor? = UIX3WaitViewController.Defaults.Color.background {
        didSet {
            self.alertView.backgroundColor = self.windowBackgroundColor
        }
    }
    open var alertBackgroundColor: UIColor? = UIX3WaitViewController.Defaults.Color.foreground {
        didSet {
            self.waitView?.backgroundColor = self.alertBackgroundColor
        }
    }
    open var textColor: UIColor? = UIX3CustomControl.Defaults.Color.text {
        didSet {
            self.titleLabel.textColor = self.textColor
        }
    }
    open var indicatorColor: UIColor? = UIX3CustomControl.Defaults.Color.text {
        didSet {
            self.activityIndicator.color = self.indicatorColor
        }
    }
// #MARK: ******* Public methods *******
    open func show() {
        if UIX3WaitViewController.Defaults.duration < 0.1 {
            UIX3WaitViewController.Defaults.duration = 0.3
        }
        showWithDuration(Double(UIX3WaitViewController.Defaults.duration))
    }
    open func hide() {
        if UIX3WaitViewController.Defaults.duration < 0.1 {
            UIX3WaitViewController.Defaults.duration = 0.3
        }
        dismissWithDuration(Double(UIX3WaitViewController.Defaults.duration))
    }
    @objc open func dismissAlertView() {
        if UIX3WaitViewController.Defaults.duration < 0.1 {
            UIX3WaitViewController.Defaults.duration = 0.3
        }
        dismissWithDuration(0.3)
    }
    
    open func showWithDuration(_ duration: Double) {
        if isNotReady || self.window == nil { return }
        self.window?.makeKeyAndVisible()
        self.view.alpha = 0
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.alpha = 1
        })
    }
    
    private func dismissCompletion() {
        self.activityIndicator.stopAnimating()
        self.parentWindow?.makeKeyAndVisible()
//        self.window?.isHidden = true
        self.window = nil
        self.parentWindow = nil
    }
    open func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete { self.dismissCompletion() }
        }
        
        self.waitView?.alpha = 1
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.alpha = 0
        }, completion: completion)
    }
}
