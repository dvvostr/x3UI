import UIKit
import x3Core

@IBDesignable open class UIX3TextField: UITextField {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupView()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    open func setupView () {
        self.rightView = rightBotton
        self.backgroundColor = UIX3CustomControl.Defaults.Color.background
        self.textColor = UIX3CustomControl.Defaults.Color.text
        self.tintColor = UIX3CustomControl.Defaults.Color.tint
        self.font = UIX3CustomControl.Defaults.inputFont
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    open func invalidate() {
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: self.textColor?.withAlphaComponent(0.4) ?? UIColor.darkText.withAlphaComponent(0.4),
                NSAttributedString.Key.font: self.placeholderFont ?? UIFont.systemFont(ofSize: 12)
            ]
        )
        if self.maxLength > 0 {
            self.text = String((self.text?.prefix(self.maxLength) ?? ""))
        }
    }
// MARK: ************ Private controls ************
    private lazy var rightBotton: UIButton = {
        let _view = UIButton(type: .custom)
        let _image = UIImage(named: "iconCirculeCancel", in: Bundle(for: UIX3TextField.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        _view.setImage(_image?.withRenderingMode(.alwaysTemplate), for: .normal)
        if #available(iOS 15.0, *) {
            _view.tintColor = UIX3TextField.appearance().tintColor ?? UIColor.tintColor
        } else {
            _view.tintColor = UIColor.darkText
        }
        _view.imageEdgeInsets = UIEdgeInsets(top: self.rightButtonImageOffset, left: self.rightButtonImageOffset, bottom: self.rightButtonImageOffset, right: self.rightButtonImageOffset)
        _view.frame = CGRect(x: 0, y: 0, width: self.rightButtonSize.width, height: self.rightButtonSize.height)
        _view.addTarget(self, action: #selector(self.handleRightButtonClick), for: .touchUpInside)
        return _view
    }()
    private lazy var leftBotton: UIButton = {
        let _view = UIButton(type: .custom)
        let _image = UIImage(color: UIColor.clear)
        _view.setImage(_image?.withRenderingMode(.alwaysTemplate), for: .normal)
        if #available(iOS 15.0, *) {
            _view.tintColor = UIX3TextField.appearance().tintColor ?? UIColor.tintColor
        } else {
            _view.tintColor = UIColor.darkText
        }
        _view.imageEdgeInsets = UIEdgeInsets(top: self.leftButtonImageOffset, left: self.leftButtonImageOffset, bottom: self.leftButtonImageOffset, right: self.leftButtonImageOffset)
        _view.frame = CGRect(x: 0, y: 0, width: self.leftButtonSize.width, height: self.leftButtonSize.height)
        _view.addTarget(self, action: #selector(self.handleLeftButtonClick), for: .touchUpInside)
        return _view
    }()

// MARK: ************ Properties ************
    open var textControlDelegate: UX3TextControlDelegate?
    open override var textColor: UIColor? {
        didSet {
            super.textColor = self.textColor
            invalidate()
        }
    }
    open override var font: UIFont? {
        didSet {
            super.font = self.font
            invalidate()
        }
    }
    open override var placeholder: String? {
        didSet { self.invalidate() }
    }
    open var placeholderFont: UIFont? {
        didSet { self.invalidate() }
    }
    open var leftButtonType: UX3TextControlButtonType = .icon
    open var leftButtonViewMode: UITextField.ViewMode = .whileEditing {
        didSet {
            self.leftViewMode = self.leftButtonViewMode
            self.setNeedsLayout()
        }
    }
    open var leftButtonImage: UIImage? {
        get {
            return (self.leftView as? UIButton)?.image(for: .normal)
        }
        set {
            if let _image = newValue {
                self.leftBotton.setImage(_image, for: .normal)
                self.leftView = self.leftBotton
            } else {
                self.leftView = nil
            }
            self.setNeedsLayout()
        }
    }
    open var leftButtonSize: CGSize = CGSize(width: 24, height: 24) {
        didSet {
            self.leftBotton.frame = CGRect(x: 0, y: 0, width: leftButtonSize.width, height: leftButtonSize.height)
            self.setNeedsLayout()
        }
    }
    open var leftButtonImageOffset: CGFloat = 0.0 {
        didSet {
            self.leftBotton.imageEdgeInsets = UIEdgeInsets(top: self.leftButtonImageOffset, left: self.leftButtonImageOffset, bottom: self.leftButtonImageOffset, right: self.leftButtonImageOffset)
            self.setNeedsLayout()
        }
    }
    open var leftButtonLeftOffset: CGFloat = 8.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    open var textEdgeInsets: UIEdgeInsets? {
        didSet {
            self.setNeedsLayout()
        }
    }
    

    open var rightButtonType: UX3TextControlButtonType = .clear
    open var rightButtonViewMode: UITextField.ViewMode = .whileEditing {
        didSet {
            self.rightViewMode = self.rightButtonViewMode
            self.setNeedsLayout()
        }
    }
    open var rightButtonImage: UIImage? {
        get {
            return self.rightBotton.image(for: .normal)
        }
        set {
            self.rightBotton.setImage(newValue, for: .normal)
            self.setNeedsLayout()
        }
    }
    open var rightButtonSize: CGSize = CGSize(width: 24, height: 24) {
        didSet {
            self.rightBotton.frame = CGRect(x: 0, y: 0, width: rightButtonSize.width, height: rightButtonSize.height)
            self.setNeedsLayout()
        }
    }
    open var rightButtonImageOffset: CGFloat = 2.0 {
        didSet {
            self.rightBotton.imageEdgeInsets = UIEdgeInsets(top: self.rightButtonImageOffset, left: self.rightButtonImageOffset, bottom: self.rightButtonImageOffset, right: self.rightButtonImageOffset)
            self.setNeedsLayout()
        }
    }
    open var rightButtonRightOffset: CGFloat = 4.0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    open override var tintColor: UIColor! {
        didSet {
            super.tintColor = self.tintColor
            self.rightBotton.tintColor = self.tintColor
        }
    }
    open var maxLength: Int = -1 {
        didSet {
            self.setNeedsLayout()
        }
    }

// MARK: ************ Private methods ************
    @objc private func handleRightButtonClick() {
        switch self.rightButtonType {
        case .button: self.textControlDelegate?.UX3TextControlRightButtonClick?(self)
        case .clear: doClear()
        default: break
        }
    }
    @objc private func handleLeftButtonClick() {
        switch self.rightButtonType {
        case .button: self.textControlDelegate?.UX3TextControlLeftButtonClick?(self)
        case .clear: doClear()
        default: break
        }
    }
    private func doClear() {
        if (self.delegate?.textFieldShouldClear?(self) ?? false) {
            self.text  = ""
        } else {
            self.text = ""
        }
        self.textControlDelegate?.UX3TextControlTextChange?(self)
    }
// MARK: ************ Public methods ************
    @objc open func textFieldDidChange() {
        if self.maxLength > 0 {
            self.text = String((self.text?.prefix(self.maxLength) ?? ""))
        }
        self.textControlDelegate?.UX3TextControlTextChange?(self)
    }
// MARK: ************ Override methods ************
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return super.canPerformAction(action, withSender: sender)
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        } else {
            return false
        }
    }
    open override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
        }
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.textRect(forBounds: bounds)
//        if self.isEditing {
//
//            return CGRect(x: _rect.x, y: _rect.y, width: _rect.width, height: _rect.height).inset(by: self.text)
//        } else {
//            return _rect
//        }
        return _rect.inset(by: self.textEdgeInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.editingRect(forBounds: bounds).inset(by: self.textEdgeInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)),
            _width = self.rightButtonType == .none ? _rect.width : _rect.width - (self.rightButtonRightOffset * 2)
        return CGRect(x: _rect.x, y: _rect.y, width: _width, height: _rect.height)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        // self.rightButtonRightOffset must be 4.0
        let _rect = super.rightViewRect(forBounds: bounds)
        return CGRect(x: _rect.x - self.rightButtonRightOffset, y: _rect.y, width: _rect.width, height: _rect.height)
    }
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.leftViewRect(forBounds: bounds)
        return CGRect(x: _rect.x + self.leftButtonLeftOffset, y: _rect.y, width: _rect.width, height: _rect.height)
    }
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
    }
}

/*
 Add a button on right view of UItextfield in such way that, text should not overlap the button
https://stackoverflow.com/questions/42082339/add-a-button-on-right-view-of-uitextfield-in-such-way-that-text-should-not-over
*/
