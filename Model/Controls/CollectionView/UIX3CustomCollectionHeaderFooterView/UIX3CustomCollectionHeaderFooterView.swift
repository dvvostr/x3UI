import UIKit

@objc open class UIX3CustomCollectionHeaderFooterView: UICollectionReusableView{
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    open func setupView(){}
}
