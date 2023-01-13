import UIKit
import x3Core

@IBDesignable open class UIX3CaptionTextField: UIX3TextField {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    deinit {
        removeObservers()
    }
    open override func setupView() {
        super.setupView()
        self.setupObservers()
        self.addSubview(labelPlaceholder)
        self.labelPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        self.constraintPlaceholderLeft = labelPlaceholder.leftAnchor.constraint(equalTo: self.leftAnchor)
        NSLayoutConstraint.activate([
            constraintPlaceholderLeft!,
            labelPlaceholder.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            labelPlaceholder.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        self.constraintPlaceholderLeft?.constant = 7
        self.addTarget(self, action: #selector(self.handleInputChange), for: .editingChanged)
        self.addTarget(self, action: #selector(self.handleInputDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.handleInputDidEnd), for: .editingDidEnd)
        self.addTarget(self, action: #selector(self.handleInputEndOnExit), for: .editingDidEndOnExit)
    }
    open func setupObservers() {
        _observations.append(self.observe(\.text, options: [.initial, .new]) { [weak self] (_view, _change) in
            guard let _self = self else { return }
            _self.handleTextChange(value: _self.text)
        })
    }
    open override func invalidate() {
        super.invalidate()
        self.labelPlaceholder.textColor = self.textColor?.withAlphaComponent(0.4) ?? UIColor.darkText.withAlphaComponent(0.4)
    }
    private func removeObservers() {
        _observations.forEach { $0.invalidate() }
        _observations.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
// MARK: ************ Private controls ************
    private var _observations: [NSKeyValueObservation] = []
    private var constraintPlaceholderLeft: NSLayoutConstraint?

    private lazy var labelPlaceholder: UILabel = {
        let _view = UILabel()
        if let _font = self.placeholderFont {
            _view.font = _font
        }
        return _view
    }()
    
// MARK: ************ Properties ************
    open var caption: String? {
        didSet{
            self.labelPlaceholder.text = self.caption
        }
    }
    open override var placeholder: String? {
        didSet {
            super.placeholder = ""
        }
    }
    open override var placeholderFont: UIFont? {
        didSet {
            self.labelPlaceholder.font = self.placeholderFont
        }
    }
// MARK: ************ Private methods ************
    @objc private func handleInputChange() {
        handleTextChange(value: self.text)
    }
    @objc private func handleInputDidBegin() {
    }
    @objc private func handleInputDidEnd() {
    }
    @objc private func handleInputEndOnExit() {
    }
    
    private func handleTextChange(value: String?) {
        let text = value ?? ""
        let lineHieght = font?.lineHeight ?? 0
        let translationY = lineHieght + 8
        let transform = text.isEmpty
            ? CGAffineTransform.identity
            : CGAffineTransform(translationX: 0, y: -translationY).scaledBy(x: 1, y: 1)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.labelPlaceholder.transform = transform
                if let _font = self.placeholderFont {
                    self.labelPlaceholder.font = text.isEmpty ? _font : _font.withSize(14)
                }
                let _color = self.textColor ?? UIColor.darkText
                self.labelPlaceholder.textColor = text.isEmpty ? _color.withAlphaComponent(0.4) : _color
            }
        )
    }
// MARK: ************ Public methods ************
// MARK: ************ Override methods ************
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.placeholderRect(forBounds: bounds)
        return _rect
    }
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.textRect(forBounds: bounds)
        return _rect
    }
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let _rect = super.editingRect(forBounds: bounds)
        return _rect
    }
}

//extension UIX3CaptionTextField: UITextFieldDelegate {}
