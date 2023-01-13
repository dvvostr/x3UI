import x3Core
import UIKit

//************************************************//
@objc open class UIX3CustomTableHeaderFooterView: UITableViewHeaderFooterView{
    class var identifier: String { return String(describing: self) }
    public static let defaultHeight: CGFloat = 50
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    open func setupView(){
    }
}


//************************************************//
