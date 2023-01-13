import UIKit

@IBDesignable open class UX3RoundedButton: UIButton {
    @IBInspectable public var normalColor: UIColor = UIColor.black {
        didSet {
            self.backgroundColor = self.normalColor
            self.layer.borderColor = self.normalColor.cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(selectedColor, for: .normal)
            self.setTitleColor(normalColor, for: .highlighted)
        }
    }
    @IBInspectable public var selectedColor: UIColor = UIColor.white {
        didSet {
            self.tintColor = self.selectedColor
            self.setTitleColor(selectedColor, for: .normal)
            self.setTitleColor(normalColor, for: .highlighted)
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            self.setTitleColor(selectedColor, for: .normal)
            self.setTitleColor(normalColor, for: .highlighted)
            DispatchQueue.main.async {
                self.alpha = 1
                self.titleLabel?.alpha = 1
                self.imageView?.alpha = 1
            }
//            UIView.animate(withDuration: isHighlighted ? 0 : 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
//                self.backgroundColor = self.isHighlighted ? self.selectedColor : self.normalColor
//                self.tintColor = self.isHighlighted ? self.normalColor : self.selectedColor
//            }, completion: nil)
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.1, animations: { () -> Void in
                self.backgroundColor = self.isHighlighted ? self.selectedColor : self.normalColor
                self.tintColor = self.isHighlighted ? self.normalColor : self.selectedColor
            }) { (finished) -> Void in }

            super.isHighlighted = self.isHighlighted
        }
    }

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
        if #available(iOS 15.0, *) {
//            var _config = UIButton.Configuration.filled()
//            _config.buttonSize = .large
//            _config.cornerStyle = .medium
//            self.configuration = _config
        } else {
        }
        self.adjustsImageWhenHighlighted = false
        self.clipsToBounds = true;
        self.initialize()
    }
    private func initialize() {
    }
    open override func layoutSubviews() {
        self.layer.cornerRadius = (cornerRadius == -1 ? (self.frame.size.height / 2.0) : cornerRadius)
        self.layer.masksToBounds = true
        super.layoutSubviews()
    }
}
