import UIKit
// https://medium.com/@mandoramuku07/customize-uisearchbar-for-different-ios-versions-6ee02f4d4419
@IBDesignable open class UIX3CustomSearchBar: UISearchBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public var input: UITextField? {
        get { return self.value(forKey: "searchField") as? UITextField }
    }
    public var cancelButton: UIBarButtonItem? {
        get { return self.value(forKey: "cancelButton") as? UIBarButtonItem }
    }
    
    open override var placeholder: String? {
        didSet {
            if let _input = self.input {
                _input.attributedPlaceholder = NSAttributedString(
                    string: self.placeholder ?? "",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIX3CustomControl.Defaults.Color.text?.withAlphaComponent(0.4) ?? UIColor.darkText.withAlphaComponent(0.4),
                        NSAttributedString.Key.font: UIX3CustomControl.Defaults.textFont.withSize(14)
                    ]
                )
            } else {
                super.placeholder = self.placeholder
            }
        }
    }
    private func setupView() {
        self.searchBarStyle = UISearchBar.Style.default
        self.backgroundColor = UIX3CustomControl.Defaults.Color.background
        self.tintColor = UIX3CustomControl.Defaults.Color.tint
        if let _input = self.input, let _clearButton = _input.value(forKey: "_clearButton")as? UIButton {
            _input.backgroundColor = UIX3CustomControl.Defaults.Color.background
            _input.layer.borderColor = UIX3CustomControl.Defaults.Color.border?.cgColor
            _input.layer.cornerRadius = UIX3CustomControl.Defaults.cornerRadius
            _input.layer.borderWidth = UIX3CustomControl.Defaults.borderWidth
            _input.leftView?.tintColor = UIX3CustomControl.Defaults.Color.tint
            _input.font = UIX3CustomControl.Defaults.textFont
            _clearButton.setImage(UIImage(named: "iconCirculeCancel", in: Bundle(for: UIX3TextField.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
            _clearButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
    }
    
    public func setInputClearImage(_ image: UIImage?) {
        self.setImage(image, for: .clear, state: .normal)
    }
}
