import UIKit

public enum UX3CustomButtonImagePosition {
    case normal, right, left, largeBtn
}
public struct UX3CustomButtonSettings {
    public struct Color {
        public var background: UIColor
        public var foreground: UIColor
        public var border: UIColor
        public init (background: UIColor, foreground: UIColor, border: UIColor) {
            self.background = background
            self.foreground = foreground
            self.border = border
        }
    }
    public var normalColor: UX3CustomButtonSettings.Color
    public var selectedColor: UX3CustomButtonSettings.Color
    public var font: UIFont = UIFont.systemFont(ofSize: 16)
    public var imageOffset: CGFloat = 10
    public var largeImageOffset: CGFloat = 4
    public var borderWidth: CGFloat = 1.0
    public var borderRadius: CGFloat = -1.0
    public var caption: String?
    public var image: UIImage?
    public init (normalColor: UX3CustomButtonSettings.Color, selectedColor: UX3CustomButtonSettings.Color, font: UIFont = UIFont.systemFont(ofSize: 16), caption: String? = nil, imageOffset: CGFloat = 10, largeImageOffset: CGFloat = 4, borderWidth: CGFloat = 1.0, borderRadius: CGFloat = -1.0) {
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        self.font = font
        self.caption = caption
        self.imageOffset = imageOffset
        self.largeImageOffset = largeImageOffset
        self.borderWidth = borderWidth
        self.borderRadius = borderRadius
    }
}
@IBDesignable open class UX3CustomButton: UIButton {
// #MARK: ******* Defaults *******
    public struct Defaults {
        public struct Color {
            public struct Normal {
                public static var background: UIColor = UIColor.clear
                public static var foreground: UIColor = UIColor.darkGray
                public static var border: UIColor = UIColor.clear
            }
            public struct Selected {
                public static var background: UIColor = UIColor.darkGray
                public static var foreground: UIColor = UIColor.white
                public static var border: UIColor = UIColor.black
            }

        }
        public static var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var imageOffset: CGFloat = 10
        public static var largeImageOffset: CGFloat = 4
        public static var borderWidth: CGFloat = 1.0
        public static var borderRadius: CGFloat = 0.0

        public static var settings: UX3CustomButtonSettings {
            get {
                let _value = UX3CustomButtonSettings(
                    normalColor: UX3CustomButtonSettings.Color(
                        background: UX3CustomButton.Defaults.Color.Normal.background,
                        foreground: UX3CustomButton.Defaults.Color.Normal.foreground,
                        border: UX3CustomButton.Defaults.Color.Normal.border
                    ),
                    selectedColor: UX3CustomButtonSettings.Color(
                        background: UX3CustomButton.Defaults.Color.Selected.background,
                        foreground: UX3CustomButton.Defaults.Color.Selected.foreground,
                        border: UX3CustomButton.Defaults.Color.Selected.border
                    ),
                    font: UX3CustomButton.Defaults.titleFont,
                    imageOffset: UX3CustomButton.Defaults.imageOffset,
                    largeImageOffset: UX3CustomButton.Defaults.largeImageOffset,
                    borderWidth: UX3CustomButton.Defaults.borderWidth,
                    borderRadius: UX3CustomButton.Defaults.borderRadius
                )
                return _value
            }
        }
    }
// #MARK: ******* Initialize & Invalidate *******

    override init(frame: CGRect) {
        super.init(frame: frame);
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupView()
    }
    convenience init(frame: CGRect, settings: UX3CustomButtonSettings) {
        self.init(frame: frame);
        setupView()
        self.initialize(settings: settings)
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    open func setupView () {
        self.adjustsImageWhenHighlighted = false
        self.clipsToBounds = true;
        self.initialize()
    }
    private func initialize() {
        self.initialize(settings: UX3CustomButton.Defaults.settings)
    }
    private func initialize(settings: UX3CustomButtonSettings) {
        self.normalBackgroundColor = settings.normalColor.background
        self.normalForegroundColor = settings.normalColor.foreground
        self.normalBorderColor = settings.normalColor.border
        self.selectedBackgroundColor = settings.selectedColor.background
        self.selectedForegroundColor = settings.selectedColor.foreground
        self.selectedBorderColor = settings.selectedColor.border
        self.titleLabel?.defaultFont = settings.font
        self.borderWidth = settings.borderWidth
        self.imageOffset = settings.imageOffset
    }
    open override func layoutSubviews() {
        self.invalidate()
        super.layoutSubviews()
    }
    public func invalidate () {
        self.backgroundColor = self.isHighlighted ? self.selectedBackgroundColor : self.normalBackgroundColor
        self.tintColor = self.isHighlighted ? self.selectedForegroundColor : self.normalForegroundColor
        self.setTitleColor(self.normalForegroundColor, for: .normal)
        self.setTitleColor(self.selectedForegroundColor, for: .highlighted)
        self.layer.borderColor = self.isHighlighted ? self.selectedBorderColor?.cgColor : self.normalBorderColor?.cgColor
        self.layer.cornerRadius = (cornerRadius == -1 ? (self.frame.size.height / 2.0) : cornerRadius)
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let _rect = super.imageRect(forContentRect: contentRect)
        if self.imagePosition == .left {
            return CGRect(x: self.imageOffset, y: _rect.origin.y, width: _rect.width, height: _rect.height)
        } else if imagePosition == .right {
            return CGRect(x: self.frame.width - _rect.width - self.imageOffset, y: _rect.origin.y, width: _rect.width, height: _rect.height)
        } else if imagePosition == .largeBtn {
            let _size = self.frame.height - (self.imageOffset * 2)
            return CGRect(x: self.imageOffset, y: self.imageOffset, width: _size, height: _size)
        } else {
            return _rect
        }
    }
// #MARK: ******* Public propertyes *******
    @IBInspectable public var normalBackgroundColor: UIColor? {
        didSet { self.invalidate() }
    }
    @IBInspectable public var normalForegroundColor: UIColor? {
        didSet { self.invalidate() }
    }
    @IBInspectable public var normalBorderColor: UIColor? {
        didSet { self.invalidate() }
    }
    @IBInspectable public var selectedBackgroundColor: UIColor?
    @IBInspectable public var selectedForegroundColor: UIColor?
    @IBInspectable public var selectedBorderColor: UIColor?
    
    open override var isHighlighted: Bool {
        didSet {
            self.setTitleColor(self.normalForegroundColor, for: .normal)
            self.setTitleColor(self.selectedForegroundColor, for: .highlighted)
            DispatchQueue.main.async {
                self.alpha = 1
                self.titleLabel?.alpha = 1
                self.imageView?.alpha = 1
            }
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.1, animations: { () -> Void in
                self.backgroundColor = self.isHighlighted ? self.selectedBackgroundColor : self.normalBackgroundColor
//                self.titleLabel?.textColor = self.isHighlighted ? self.selectedForegroundColor : self.normalForegroundColor
                self.tintColor = self.isHighlighted ? self.selectedForegroundColor : self.normalForegroundColor
            }) { (finished) -> Void in }
            super.isHighlighted = self.isHighlighted
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    public var font: UIFont? {
        get {
            return titleLabel?.defaultFont
        }
        set {
            self.titleLabel?.defaultFont = newValue
        }
    }
    public var imagePosition: UX3CustomButtonImagePosition = .normal {
        didSet { self.layer.setNeedsDisplay() }
    }
    public var imageOffset: CGFloat = UX3CustomButton.Defaults.imageOffset {
        didSet { self.layer.setNeedsDisplay() }
    }
}
