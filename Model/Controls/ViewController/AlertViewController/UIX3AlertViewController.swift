import UIKit
import x3Core

@IBDesignable open class UIX3AlertViewController: UIX3CustomAlertViewController {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
    
    public struct Defaults {
        public struct AlertView {
            public static var buttonOKSettings: UX3CustomButtonSettings?
            public static var buttonCancelSettings: UX3CustomButtonSettings?
            public static var buttonHelpSettings: UX3CustomButtonSettings?
            public struct Color {
                public static var message: UIColor? = UIX3CustomControl.Defaults.Color.text
                public static var caption: UIColor? = UIX3CustomControl.Defaults.Color.text
            }
            public static var paddingX: CGFloat = 12.0
            public static var paddingY: CGFloat = 20.0
            public static var imageSize: CGFloat = 32.0
            public static var headerFont: UIFont? = UIFont.systemFont(ofSize: 15)
            public static var messageFont: UIFont? = UIFont.systemFont(ofSize: 14)
        }
        public struct Color {
            public static var background: UIColor? = UIColor.systemFill.withAlphaComponent(0.3)
        }
        public static var duration: CGFloat = 0.3
        public static var showAnimation: Int = 0
    }
// MARK: ************ Initialize & invalidate ************
    open override func setupView() {
        super.setupView()
        self.invalidateButtonView()
        self.invalidate()
    }
    open override func invalidate() {
        let _paddingX: CGFloat = UIX3AlertViewController.Defaults.AlertView.paddingX,
            _paddingY: CGFloat = UIX3AlertViewController.Defaults.AlertView.paddingY
        var _height: CGFloat = _paddingY
        let _width: CGFloat = self.alertSize == .fixed ? self.alertWidth : self.alertWidth > 90 ? self.view.bounds.width * 0.9 : self.view.bounds.width * (self.alertWidth / 100)
        var _right: CGFloat = 0.0
        let _imageSize = UIX3AlertViewController.Defaults.AlertView.imageSize
        
        self.alertView?.layer.borderColor = self.borderColor?.cgColor ?? UIColor.clear.cgColor
        self.alertView?.layer.borderWidth = self.borderWidth
        self.alertView?.layer.cornerRadius = self.cornerRadius

        self.imageView?.removeFromSuperview()
        if let _view = imageView, let _image = self.image {
            self.alertView?.addSubview(_view)
            _view.image = _image
            _view.layer.cornerRadius = _imageSize / 2
            _view.frame = CGRect(x: _paddingX, y: _height, width: _imageSize, height: _imageSize)
            _right = _imageSize + 8 // (_paddingX * 1) + _imageSize
        }

        self.labelCaption?.removeFromSuperview()
        if let _label = labelCaption, let _caption = self.caption, !_caption.isEmpty {
            self.alertView?.addSubview(_label)
            _label.text  = _caption
            let size = _label.sizeThatFits(CGSize(width: _width - _paddingX * 2, height: 600)),
                _val = size.height * 1.50
            _label.frame = CGRect(x: _paddingX + _right, y: _height, width: _width - _right - _paddingX * 2, height: _val)
            _height += _val
        }

        self.labelMessage?.removeFromSuperview()
        if let _label = labelMessage {
            self.alertView?.addSubview(_label)
            if let _message = self.message {
                _label.text  = _message
            } else if let messageAttributedString = self.messageAttributedString {
                _label.attributedText = messageAttributedString
            }
            let size = _label.sizeThatFits(CGSize(width: _width - _paddingX * 2, height: 600))
            _label.frame = CGRect(x: _paddingX + _right, y: _height, width: _width - _right - _paddingX * 2, height: size.height)
            _height += size.height + _paddingY
        }
        self.buttonToolbar?.removeFromSuperview()
        if let _view = self.buttonToolbar, self.buttonOptions.count > 0 {
            _height += 4
            self.alertView?.addSubview(_view)
            _view.frame = CGRect(x: 0, y: _height, width: _width, height: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.height)
            _view.subviews.first?.getContraints(attribute: .trailing, relation: nil).forEach({ $0.constant = 0 })
            _height += _paddingY + _view.frame.height
        }

        self.bgView?.frame = self.view.bounds
        let _rect = CGRect(
            x: self.view.bounds.width / 2 - (_width / 2),
            y: self.view.bounds.height / 2 - (_height / 2),
            width: _width,
            height: _height
        )
        self.alertView?.frame = _rect
    }
    open override func invalidateButtonView() {
        super.invalidateButtonView()
        var _items: [UIBarButtonItem] = []
        if self.buttonOptions.elements().contains(.help) {
            let _button = createButton(.help, settings: self.getButtonSettings(.help))
            _button.imagePosition = .largeBtn
            _button.imageOffset = 4
            _items.append(UIBarButtonItem(customView: _button))
        }
        _items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        if self.buttonOptions.elements().contains(.cancel) {
            _items.append(UIBarButtonItem(customView: createButton(.cancel, settings: self.getButtonSettings(.cancel))))
        }
        if self.buttonOptions.elements().contains(.ok) {
            _items.append(UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil).setProperty(width: UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing))
            _items.append(UIBarButtonItem(customView: createButton(.ok, settings: self.getButtonSettings(.ok))))
        }
        self.buttonToolbar?.setItems(_items, animated: false)
        self.buttonToolbar?.isUserInteractionEnabled = true
        self.buttonToolbar?.sizeToFit()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    deinit {
    }
// #MARK: ******* Handles *******
    open override func buttonViewClick(_ sender: UX3CustomButton, buttonType: UIX3CustomAlertButtonType) {
        super.buttonViewClick(sender, buttonType: buttonType)
    }
// #MARK: ******* Private propertyes *******
    private var window: UIWindow?
    private var parentWindow: UIWindow?
    private var buttons = [UIButton]()
    private lazy var bgView: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIX3AlertViewController.Defaults.Color.background
        _view.isUserInteractionEnabled = true
        return _view
    }()
    private lazy var imageView: UIImageView? = {
        let _view = UIImageView()
        _view.contentMode = .scaleToFill
        _view.layer.masksToBounds = true
        return _view
    }()
    private lazy var labelCaption: UILabel? = {
        let _view = UILabel(frame: .zero)
        _view.numberOfLines = 1
        _view.backgroundColor = UIColor.clear
        _view.textColor = UIX3AlertViewController.Defaults.AlertView.Color.caption
        _view.textAlignment = NSTextAlignment.left
        _view.font = UIX3AlertViewController.Defaults.AlertView.messageFont ?? UIFont.systemFont(ofSize: 15)
        return _view
    }()
    private lazy var labelMessage: UILabel? = {
        let _view = UILabel(frame: .zero)
        _view.numberOfLines = 0
        _view.backgroundColor = UIColor.clear
        _view.textColor = UIX3AlertViewController.Defaults.AlertView.Color.message
        _view.textAlignment = NSTextAlignment.justified
        _view.font = UIX3AlertViewController.Defaults.AlertView.messageFont ?? UIFont.systemFont(ofSize: 14)
        return _view
    }()
    private lazy var buttonToolbar: UIToolbar? = {
        let _view = UIToolbar()
        _view.clipsToBounds = true
        _view.isTranslucent = false
        _view.backgroundColor = UIColor.clear
        return _view
    }()
    private lazy var buttonView: UIStackView? = {
        let _view = UIStackView()
        _view.axis = .horizontal
        _view.alignment = .fill
        _view.distribution = .fillProportionally
        _view.spacing = UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing
        return _view
    }()
    private lazy var messageView: UIView? = {
        let _view = UIView(frame: .zero)
        _view.backgroundColor = UIColor.clear
        return _view
    }()
// #MARK: ******* Public propertyes *******
    open var image: UIImage?
    open var caption: String?
    open var message: String?

    open var headerFont: UIFont? = UIX3AlertViewController.Defaults.AlertView.messageFont
    open var messageFont: UIFont? = UIX3AlertViewController.Defaults.AlertView.headerFont

    open var messageAttributedString: NSAttributedString?

// #MARK: ******* Public methods *******
}
