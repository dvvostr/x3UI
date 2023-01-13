import UIKit

@objc open class UIX3TableViewCustomCell: UITableViewCell {
    public weak var cellDelegate: UIX3TableViewCustomCellDelegate?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    open func setupView(){
    }
}
