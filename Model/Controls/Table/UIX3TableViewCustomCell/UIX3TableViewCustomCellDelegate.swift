import UIKit

@objc public protocol UIX3TableViewCustomCellDelegate: AnyObject {
    @objc optional func customCellChange(sender: Any?, data: Any?)
    @objc optional func customCellCancel(sender: Any?)
    @objc optional func customCellSelectedChange(sender: Any)
    @objc optional func customCellPopupChange(sender: Any?)
}
