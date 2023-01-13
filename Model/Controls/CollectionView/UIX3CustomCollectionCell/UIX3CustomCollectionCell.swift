// UIX3CustomCollectionCell
import UIKit
import x3Core

@objc open class UIX3CustomCollectionCell: UICollectionViewCell{
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    open var defaultHeight: CGFloat {
        get{ return 52.0 }
    }
    
    open func setupView(){}
}
