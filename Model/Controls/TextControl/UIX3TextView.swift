import Foundation
import x3Core
import UIKit

@IBDesignable open class UIX3TextView: UIX3CustomView, UITextViewDelegate {
// MARK: ******* Defaults *******
    public struct Defaults {
        public struct Color {
        }
        public static var textInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        public static var buttonSize: CGSize = CGSize(width: 24, height: 24)
    }
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    public override init(frame: CGRect) {
        super.init(frame: frame);
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    deinit {
        removeObservers()
    }
    private func removeObservers() {
        _fieldObservations.forEach { $0.invalidate() }
        _fieldObservations.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    open override func setupView () {
        super.setupView()
//        self.translatesAutoresizingMaskIntoConstraints = true
        self.setupObservers()
        self.addSubview(textView)
        self.insertSubview(_placeholderView, at: 0)
    }
    open func setupObservers() {
        _fieldObservations.append(self.observe(\.frame, options: [.initial, .new]) { [weak self] (_view, _change) in
            guard let _self = self else { return }
            _self.invalidateTextView(frame: _view.bounds)
        })
        _fieldObservations.append(self.textView.observe(\UITextView.textContainerInset, options: [.initial, .new]) { [weak self] (_textView, _change) in
            guard let _self = self else { return }
            _self._placeholderView.textContainerInset = _textView.textContainerInset
        })
        _fieldObservations.append(
            self.textView.textContainer.observe(\.lineFragmentPadding, options: [.initial, .new]) { [weak self] (_textContainer, _changes) in
                self?._placeholderView.textContainer.lineFragmentPadding = _textContainer.lineFragmentPadding
            }
        )
    }
    open override func invalidate() {
        self.invalidateTextView(frame: self.bounds)
        self.setNeedsLayout()
    }
    private func invalidateTextView(frame: CGRect, isEditing: Bool = false) {
        let _textInset = self.textView.textContainerInset
        var _frame = frame,
            _isLeftBotton = (self.leftButtonType != .none) && (self.leftBotton?.image(for: .normal) != nil),
            _isRightBotton = (self.rightButtonType != .none) && (self.rightBotton?.image(for: .normal) != nil)
        if _isLeftBotton, let _btn = self.leftBotton {
            self.addSubview(_btn)
            let _offset: CGFloat = self.leftButtonSize.width + (self.leftButtonLeftOffset * 2) - self.textInsets.left
            _frame = CGRect(x: _offset, y: _frame.y, width: _frame.width - _offset, height: _frame.height)
            let _btnFrame = CGRect(
                x: self.leftButtonLeftOffset,
                y: (self.bounds.center.y - ((self.leftButtonSize.height + self.leftButtonImageOffset + self.leftButtonLeftOffset) / 2)),
                width: self.leftButtonSize.width,
                height: self.leftButtonSize.height
            )
            self.leftBotton?.frame = _btnFrame
        } else {
            _isLeftBotton = false
            self.leftBotton?.removeFromSuperview()
        }
        if _isRightBotton, let _btn = self.rightBotton {
            self.addSubview(_btn)
            let _offset: CGFloat = self.rightButtonSize.width + (self.rightButtonRightOffset * 2) - self.textInsets.right
            _frame = CGRect(x: _frame.x, y: _frame.y, width: _frame.width - _offset, height: _frame.height)
            let _btnFrame = CGRect(
                x: frame.width - (self.rightButtonSize.width + self.rightButtonRightOffset),
                y: (frame.center.y - ((self.rightButtonSize.height + self.rightButtonImageOffset + self.rightButtonRightOffset) / 2)),
                width: self.rightButtonSize.width,
                height: self.rightButtonSize.height
            )
            self.rightBotton?.frame = _btnFrame
        } else {
            _isRightBotton = false
            self.rightBotton?.removeFromSuperview()
        }

        self.textView.textContainerInset = UIEdgeInsets(
                top: _textInset.top,
                left: _isLeftBotton ? 0 : _textInset.left,
                bottom: _textInset.bottom,
                right: _isRightBotton ? 0: _textInset.right
        )

        self.textView.frame = _frame.inset(by: self.textInsets)
        self._placeholderView.frame = self.textView.frame

    }
// MARK: ************ Private variabled & controls ************
    private var _fieldObservations: [NSKeyValueObservation] = []
// MARK: ************ Private controls ************
    private lazy var _placeholderView: UITextView = {
        let _view = UITextView()
        _view.frame = self.bounds
        _view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.text = "Placeholder"
        _view.isEditable = false
        _view.textColor = UIColor(white: 0.7, alpha: 1)
        _view.backgroundColor = .clear
        return _view
    }()
    private lazy var textView: UITextView = {
        let _view = UITextView()
        _view.frame = self.bounds
        _view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.isEditable = true
        _view.delegate = self
        _view.backgroundColor = UIColor.clear
        return _view
    }()
    private lazy var rightBotton: UIButton? = {
        let _view = UIButton(type: .custom)
        _view.contentHorizontalAlignment = .fill
        _view.contentVerticalAlignment = .fill
        _view.imageView?.contentMode = .scaleAspectFit
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
    private lazy var leftBotton: UIButton? = {
        let _view = UIButton(type: .custom)
        _view.contentHorizontalAlignment = .fill
        _view.contentVerticalAlignment = .fill
        _view.imageView?.contentMode = .scaleAspectFit
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
// MARK: ************ Public propertyes ************
    open var textControlDelegate: UX3TextControlDelegate?

    public var textInsets: UIEdgeInsets = UIX3TextView.Defaults.textInsets {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable public var textColor: UIColor? {
        didSet {
            self.textView.textColor = self.textColor
            if self.placeholderTextColor == nil {
                self.placeholderTextColor = self.textColor?.withAlphaComponent(0.4)
            }
        }
    }
    @IBInspectable public var placeholderTextColor: UIColor? {
        didSet{
            self._placeholderView.textColor = self.placeholderTextColor
        }
    }
    @IBInspectable open override var tintColor: UIColor! {
        didSet {
            self.leftBotton?.tintColor = self.tintColor
            self.rightBotton?.tintColor = self.tintColor
        }
    }
    public var font: UIFont? {
        didSet {
            self.textView.font = self.font
            if placeholderFont == nil {
                self.placeholderFont = self.font?.withSize((self.font?.pointSize ?? 16) * 0.875)
            }
        }
    }
    public var placeholderFont: UIFont? {
        didSet {
            self._placeholderView.font = self.placeholderFont
        }
    }
    public var leftButtonType: UX3TextControlButtonType = .none {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var leftButtonImage: UIImage? {
        get { return (self.leftBotton?.image(for: .normal)) }
        set {
            self.leftBotton?.setImage(newValue, for: .normal)
            invalidate()
        }
    }
    open var leftButtonSize: CGSize = CGSize(width: 32, height: 32) {
        didSet {
            if let _btn = self.leftBotton {
                _btn.frame = CGRect(x: 0, y: 0, width: leftButtonSize.width, height: leftButtonSize.height)
                self.invalidate()
            }
        }
    }
    @IBInspectable open var leftButtonImageOffset: CGFloat = 0.0 {
        didSet {
            self.leftBotton?.imageEdgeInsets = UIEdgeInsets(top: self.leftButtonImageOffset, left: self.leftButtonImageOffset, bottom: self.leftButtonImageOffset, right: self.leftButtonImageOffset)
//            self.invalidate()
        }
    }
    @IBInspectable open var leftButtonLeftOffset: CGFloat = 8.0 {
        didSet {
            self.invalidate()
        }
    }
    public var rightButtonType: UX3TextControlButtonType = .clear {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var rightButtonImage: UIImage? {
        get {
            return self.rightBotton?.image(for: .normal)
        }
        set {
            self.rightBotton?.setImage(newValue, for: .normal)
            self.invalidate()
        }
    }
    open var rightButtonSize: CGSize = UIX3TextView.Defaults.buttonSize {
        didSet {
            self.rightBotton?.frame = CGRect(x: 0, y: 0, width: rightButtonSize.width, height: rightButtonSize.height)
            self.invalidate()
        }
    }
    @IBInspectable open var rightButtonImageOffset: CGFloat = 2.0 {
        didSet {
            self.rightBotton?.imageEdgeInsets = UIEdgeInsets(top: self.rightButtonImageOffset, left: self.rightButtonImageOffset, bottom: self.rightButtonImageOffset, right: self.rightButtonImageOffset)
            self.invalidate()
        }
    }
    @IBInspectable open var rightButtonRightOffset: CGFloat = 4.0 {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var text: String? {
        get {
            return self.textView.text
        }
        set {
            self.textView.text = newValue
            self.textViewDidChange(self.textView)
        }
    }
    @IBInspectable open var placeholder: String? {
        get {
            return self._placeholderView.text
        }
        set {
            self._placeholderView.text = newValue
        }
    }
    @IBInspectable open var borderColor: UIColor? = UIX3CustomControl.Defaults.Color.border {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = UIX3CustomControl.Defaults.cornerRadius {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    @IBInspectable open var borderWidth: CGFloat = UIX3CustomControl.Defaults.borderWidth {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
// MARK: ************ Handle methods ************
    @objc private func handleLeftButtonClick() {
        switch self.rightButtonType {
        case .button: self.textControlDelegate?.UX3TextControlRightButtonClick?(self)
        case .clear: doClear()
        default: break
        }
    }
    @objc private func handleRightButtonClick() {
        switch self.rightButtonType {
        case .button: self.textControlDelegate?.UX3TextControlLeftButtonClick?(self)
        case .clear: doClear()
        default: break
        }
    }
// MARK: ************ Private methods ************
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateTextView(frame: self.bounds)
    }
    public func textViewDidChange(_ textView: UITextView) {
        let _isEditing = !textView.text.isEmpty || !textView.attributedText.string.isEmpty
        _placeholderView.isHidden = _isEditing
        _placeholderView.setContentOffset(.zero, animated: false)
        self.invalidateTextView(frame: self.bounds, isEditing: _isEditing)
    }
    private func doClear() {
        self.textView.text = ""
        self.textViewDidChange(self.textView)
        self.textControlDelegate?.UX3TextControlTextChange?(self)
    }
}

