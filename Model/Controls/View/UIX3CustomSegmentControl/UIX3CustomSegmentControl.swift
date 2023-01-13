import UIKit
import x3Core

public typealias SegmentedControlItems = [String]

// @IBDesignable
@objc public class UIX3CustomSegmentControl: UIX3XibView {
    public struct Defaults {
        public struct Color {
            public static var inactive: UIColor? = UIColor.lightGray
        }

    }
    @IBInspectable open var verticalOffset: CGFloat = 10 {
        didSet {
            self.constraintTopOffset?.constant = self.verticalOffset
            self.constraintBottomOffset?.constant = self.verticalOffset
        }
    }
    
    @IBInspectable open var horizontalOffset: CGFloat = 10 {
        didSet {
            self.constraintLeftOffset?.constant = self.horizontalOffset
            self.constraintRightOffset?.constant = self.horizontalOffset
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 10 {
        didSet {
            self.segmentedControl?.cornerRadius = self.cornerRadius
            invalidate()
        }
    }
    @IBInspectable open var backColor: UIColor? {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var foregroundColor: UIColor?  {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open override var tintColor: UIColor?  {
        didSet {
            super.tintColor = self.tintColor
            self.segmentedControl?.tintColor = self.tintColor
        }
    }
    @IBInspectable open var indicatorColor: UIColor?  {
        didSet {
            self.segmentedControl?.indicatorColor = self.indicatorColor
        }
    }
    @IBInspectable open var font: UIFont? {
        didSet {
            self.invalidate()
        }
    }
    public var items: SegmentedControlItems = [] {
        didSet {
            self.setSegmentedControlItems(self.items)
        }
    }
    @IBInspectable open var foregroundHeight: CGFloat = -1 {
        didSet {
            self.segmentedControl?.foregroundHeight = self.foregroundHeight
        }
    }
    public var delegate: ControlEventDelegate?
    
    @IBOutlet private weak var segmentedControl: UIX3SegmentControl?

    @IBOutlet private weak var constraintTopOffset: NSLayoutConstraint?
    @IBOutlet private weak var constraintBottomOffset: NSLayoutConstraint?
    @IBOutlet private weak var constraintLeftOffset: NSLayoutConstraint?
    @IBOutlet private weak var constraintRightOffset: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    open override func setupView(){
        super.setupView()
//        self.verticalOffset = 10
//        self.horizontalOffset = 10
//        self.cornerRadius = 8
//        self.tintColor = UIX3CustomControl.Defaults.Color.tint
        self.invalidate()
    }
    
    open func invalidate() {
        // *** Setup segment control *** //
        self.backgroundColor = self.backColor ?? UIX3CustomControl.Defaults.Color.background
        self.segmentedControl?.backgroundColor = self.backColor ?? UIX3CustomSegmentControl.Defaults.Color.inactive
        self.segmentedControl?.foregroundColor = self.foregroundColor ?? UIX3CustomControl.Defaults.Color.background
        self.segmentedControl?.tintColor = self.tintColor ?? UIX3CustomControl.Defaults.Color.tint
        self.segmentedControl?.font = self.font ?? UIX3CustomControl.Defaults.smallFont
        let _image = UIImage(color: UIX3CustomControl.Defaults.Color.background ?? UIColor.clear, size: CGSize(width: 0.2, height: self.segmentedControl?.frame.height ?? 36 * 0.8))
        self.segmentedControl?.setDividerImage(_image, forLeftSegmentState: .normal, rightSegmentState: .selected, barMetrics: .default)
        self.segmentedControl?.addTarget(self, action: #selector(handleSegmentValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    private func setSegmentedControlItems(_ values: SegmentedControlItems) {
        self.segmentedControl?.removeAllSegments()
        for (_i, _item) in values.enumerated() {
            self.segmentedControl?.insertSegment(withTitle: _item, at: _i, animated: false)
        }
        if self.segmentedControl?.numberOfSegments ?? 0 > 0 {
            self.segmentedControl?.selectedSegmentIndex = 0
            self.segmentedControl?.sendActions(for: .valueChanged)
        }
        self.invalidate()
    }
    @objc private func handleSegmentValueChanged(sender: Any?) {
        if let _index = self.segmentedControl?.selectedSegmentIndex, _index >= 0 {
            self.delegate?.controlEvent?(self, event: ControlEvent.enumiratedString(_index, segmentedControl?.titleForSegment(at: _index)))
        }
    }
}
