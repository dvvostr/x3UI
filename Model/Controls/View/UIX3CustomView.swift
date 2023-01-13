import UIKit

@IBDesignable open class UIX3CustomView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame);
        setupView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
        setupView()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    open func setupView () {
    }
    open func invalidate() {
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
