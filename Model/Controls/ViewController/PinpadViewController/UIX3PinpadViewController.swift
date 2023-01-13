import UIKit
import x3Core

@objc open class UIX3PinpadViewController: UIX3CustomViewController {
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
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    open override func setupView() {
        super.setupView()
        self.setupWindow()
    }
    public func setupWindow() {
    }
    open override func invalidate() {
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
}
