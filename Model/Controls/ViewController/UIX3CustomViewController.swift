import UIKit
import x3Core

public class UIBaseNavigationTitleLabel: UILabel {}
public class UIBaseNavigationTitleView: UIView {}
public class UIBaseNavigationBarButtonItem: UIBarButtonItem {}

@objc public protocol UIX3CustomViewControllerDelegate {
    @objc optional func customViewController(sender: UIX3CustomViewController) -> (Void)
    @objc optional func customViewController(willSetupFor sender: UIX3CustomViewController) -> (Void)
    @objc optional func customViewController(titleFor sender: UIX3CustomViewController) -> String
    @objc optional func customViewController(sender: UIX3CustomViewController, keyboardRect: Any?, duration: Double, options: Any?) -> (Void)
    @objc optional func customViewController(sender: UIX3CustomViewController, keyboardTopPosition: CGFloat, duration: Double, options: Any?) -> (Void)
    @objc optional func customViewController(sender: UIX3CustomViewController, statusBarStyle: UIStatusBarStyle) -> (Void)
    @objc optional func customViewController(sender: UIX3CustomViewController, orientation: UIDeviceOrientation, isLandscape: Bool) -> (Void)
}


@IBDesignable @objc open class UIX3CustomViewController: UIViewController {
    // #MARK: ******* Classes *******
    // #MARK: ******* Config *******
    public struct Defaults {
        public struct Color {
        }
        public static var navigationBackSize: CGFloat = 38
        public static var navigationBackImage: UIImage?
        public static var navigationBackBackgroundColor: UIColor?
        public static var navigationBackTintColor: UIColor?
        public static var navigationBackRadius: CGFloat? = -1
        public static var navigationBackOffset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        public static var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    }
    // #MARK: ******* private variables *******
    private var _keyboardIsHidden: Bool = false

    lazy private var _titleView: UIBaseNavigationTitleLabel = {
        let _view = UIBaseNavigationTitleLabel()
        _view.textAlignment = .center
        _view.textColor = UIBaseNavigationTitleLabel.appearance().textColor
        _view.font = UIBaseNavigationTitleLabel.appearance().defaultFont
        return _view
    }()

    lazy internal var navigationBackButton: UIBarButtonItem = {
        let _btn = UIButton.init(type: .custom)
        if let _image = UIX3CustomViewController.Defaults.navigationBackImage {
            _btn.setImage(_image, for: UIControl.State.normal)
        }
        if let _val = UIX3CustomViewController.Defaults.navigationBackBackgroundColor {
            _btn.backgroundColor = _val
        }
        if let _val = UIX3CustomViewController.Defaults.navigationBackTintColor {
            _btn.tintColor = _val
        }
        if let _val = UIX3CustomViewController.Defaults.navigationBackRadius {
            _btn.clipsToBounds = true
            _btn.layer.masksToBounds = true
            _btn.layer.cornerRadius = _val
        }
        _btn.frame = CGRect(x: 0, y: 3, width: UIX3CustomViewController.Defaults.navigationBackSize, height: UIX3CustomViewController.Defaults.navigationBackSize)
        _btn.contentEdgeInsets = UIX3CustomViewController.Defaults.navigationBackOffset
        _btn.addTarget(self, action: #selector(handleBack(sender:)), for:.touchUpInside)
        
        return UIBarButtonItem.init(customView: _btn)
    }()

// #MARK: ******* public variables *******
    public var addToNavigation : Bool = true
    public var customDelegate: UIX3CustomViewControllerDelegate?
    
    public var id: String = { return UUID().uuidString }()
    public var ownerId: String?
    
    @IBInspectable public var backgroundColor: UIColor = UIColor.clear {
        didSet{ self.view.backgroundColor = self.backgroundColor }
    }
    
    public var captionFont: UIFont {
        get{
            return self._titleView.font
        }
        set{
            self._titleView.font = newValue
            self._titleView.sizeToFit()
        }
    }

    open var titleView: UIView? {
        get {
            return self._titleView
        }
        set {
            self.navigationItem.titleView = newValue
        }
    }

    open var captionText: String = "" {
        didSet{
            self._titleView.text = self.captionText
            self._titleView.sizeToFit()
        }
    }
    
    open var captionAttributedText: NSAttributedString? {
        didSet{
            self._titleView.attributedText = self.captionAttributedText
            self._titleView.numberOfLines = 0
            self._titleView.sizeToFit()
        }
    }
    
    open var navBackImage: UIImage? {
        didSet {
            if let  _image = self.navBackImage, let _nav = self.navigationController {
                _nav.navigationBar.backIndicatorImage = _image
                _nav.navigationBar.backIndicatorTransitionMaskImage = _image
            }
        }
    }
    
    open var keyboardIsHidden: Bool {
        get{ return _keyboardIsHidden }
    }

    open var rootViewController: UIViewController? {
        get{
            if let _window = UIApplication.keyWindow, let _vc = _window.rootViewController {
                return _vc
            } else if let _vc = self.navigationController?.viewControllers.first {
                return _vc
            } else {
                return self
            }
        }
    }
// #MARK: ******* Initialization *******
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.customDelegate?.customViewController?(willSetupFor: self)
        self.initialize()
        self.setupView()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] notification in
            self?.handleKeyboardNotification(notification: notification as NSNotification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { [weak self] notification in
            self?.handleKeyboardShow(notification: notification as NSNotification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { [weak self] notification in
            self?.handleKeyboardHide(notification: notification as NSNotification)
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        self.filallize()
    }
    
    open func setupView(){
        self.navigationItem.titleView = self._titleView
        if let _str = self.customDelegate?.customViewController?(titleFor: self) {
            self.captionText = _str
        }
        if let _ = UIX3CustomViewController.Defaults.navigationBackImage {
            self.navigationItem.leftBarButtonItems = [self.navigationBackButton]
        }
        self.view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        self.view.tintColor = UIX3CustomControl.Defaults.Color.tint
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorSchemeChange(notification: )), name: Notification.Name.colorSchemeChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEndEditing(sender:)), name: Notification.Name.endEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    open class func create<T: UIX3CustomViewController>(caption: String?) -> T{
        let _vc = T.init()
        _vc.title = caption
        _vc.initialize()
        return _vc
    }
    open class var nibExists: Bool {
        get {
            return Bundle.main.path(forResource: String(describing: self), ofType: "nib") != nil
        }
    }

    open class func createNavigation<T: UIX3CustomViewController>(_ type: T.Type, caption: String?) -> UINavigationController {
        let _vc = T.fromNib()
        _vc.title = caption
        _vc.captionText = caption ?? ""
        return UINavigationController(rootViewController: _vc)
    }
    open class func createNavigationFromNib<T: UIX3CustomViewController>(_ type: T.Type, caption: String?, navBackImage: UIImage? = nil) -> UINavigationController {
        let _vc = T.fromNib()
        _vc.title = caption
        _vc.captionText = caption ?? ""
        let _nav = UINavigationController(rootViewController: _vc)
        if let _image = navBackImage {
            _nav.navigationBar.backIndicatorImage = _image
            _nav.navigationBar.backIndicatorTransitionMaskImage = _image
        }
        _nav.navigationItem.backBarButtonItem = UIBaseNavigationBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        _nav.extendedLayoutIncludesOpaqueBars = true
        return _nav
    }
// #MARK: ******* Invalidate & Repaint *******
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        var _style: UIStatusBarStyle = .lightContent
        if #available(iOS 13.0, *) {
            _style = (self.traitCollection.userInterfaceStyle == .dark ) ? .darkContent : .lightContent
        } else {
            _style = super.preferredStatusBarStyle
        }
        self.customDelegate?.customViewController?(sender: self, statusBarStyle: _style)
        return _style
    }
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsStatusBarAppearanceUpdate()
    }

// #MARK: ******* Handles *******
    @objc private func handleEndEditing(sender: Any?) {
        self.view.endEditing(true)
    }
    @objc private func handleBack(sender: Any?) {
        if self.navigationController?.viewControllers.first == self {
            self.navigationBack()
        } else {
//            let _index = self.navigationController?.viewControllers.index(before: self.navigationController?.viewControllers.index(of: self) ?? -1) ?? -1
            var _target: UIViewController? = nil
            self.navigationController?.viewControllers.reversed().forEach({
                if _target == nil {
                    if let _vc = $0 as? UIX3CustomViewController, _vc != self {
                        _target = _vc.addToNavigation ? _vc : nil
                    } else if $0 != self {
                        _target = $0
                    }
                }
            })
            if let _vc = _target {
                self.navigationController?.popToViewController(_vc, animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    @objc private func handleColorSchemeChange(notification: NSNotification?){
        self.ColorSchemeChange()
    }
    @objc private func handleDeviceRotate() {
        let _orientation = UIDevice.current.orientation,
            _isLandscape = [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(_orientation)
        self.invalidate()
        self.deviceRotateEvent(orientation: _orientation, isLandscape: _isLandscape)
        self.customDelegate?.customViewController?(sender: self, orientation: _orientation, isLandscape: _isLandscape)
    }
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let _info = notification.userInfo {
            self.view.layoutIfNeeded()
            let _endFrame = (_info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let _duration: TimeInterval = (_info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let _curveRaw = _info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let _curve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: _curveRaw?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue)
            self.keyboardEvent(duration: _duration, options: _curve, rect: _endFrame)
            self.customDelegate?.customViewController?(sender: self, keyboardRect: _endFrame, duration: _duration, options: _curve)
            let _offset = CGFloat(UIApplication.keyWindow?.frame.height ?? 0) - self.view.frame.origin.y - self.view.frame.height
            let _val = ((UIApplication.keyWindow?.frame.height ?? 0) == (_endFrame?.origin.y ?? 0)) ? 0 : CGFloat(_endFrame?.height ?? 0) - _offset
            self.keyboardEvent(duration: _duration, options: _curve, bottomPosition: _val)
            self.customDelegate?.customViewController?(sender: self, keyboardTopPosition: _val, duration: _duration, options: _curve)
        }
    }
    @objc private func handleKeyboardShow(notification: NSNotification) {
        self.keyboardStateChange(isHidden: false)
    }
    @objc private func handleKeyboardHide(notification: NSNotification) {
        self.keyboardStateChange(isHidden: true)
    }
// #MARK: ******* Dynamic methods *******
    open func initialize(){ }
    open func filallize(){ }
    open func invalidate(){ }
    open func ColorSchemeChange(){ }
    open func navigationBack() { }
    open func reset(){ }
    open func reload(){ }
    open func internalReloadData(){ }
    @objc open dynamic func deviceRotateEvent(orientation: UIDeviceOrientation, isLandscape: Bool) { }
    open func keyboardEvent(duration: Double, options: UIView.AnimationOptions, rect: CGRect?){ }
    open func keyboardEvent(duration: Double, options: UIView.AnimationOptions, bottomPosition: CGFloat){ }
    open func keyboardStateChange(isHidden: Bool){
        NotificationCenter.default.post(Notification(name: Notification.Name.keyboardStateChange, object: isHidden))
        self._keyboardIsHidden = isHidden
    }
    open func load(params: Any? = nil, showWait: Bool = false, completion: @escaping OnDataResult){
        completion(DataResult.success, nil)
    }
}
 
