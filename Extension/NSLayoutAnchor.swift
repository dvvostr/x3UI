import UIKit

extension NSLayoutAnchor {
    @objc open func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat, isActive: Bool) -> NSLayoutConstraint {
        let _constraint = constraint(equalTo: anchor, constant: c)
        _constraint.isActive = isActive
        return _constraint
    }
}
