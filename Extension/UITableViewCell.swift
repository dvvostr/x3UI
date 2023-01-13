import UIKit

public extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}
