import UIKit

public enum VerticalLocation: String {
    case bottom
    case top
}

public class UIViewBorder: UIView {}

public extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0, height: CGFloat = 7) {
        var _color = color
        if #available(iOS 12.0, *) {
            _color = self.parentViewController?.traitCollection.userInterfaceStyle ?? .light == .dark ? color.invert() ?? color : color
        }
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: height), color: _color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -height), color: _color, opacity: opacity, radius: radius)
        }
    }    
    func anchorSize(widthConstant: CGFloat, heightConstant: CGFloat) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        anchors.forEach({$0.isActive = true})
        return anchors
    }
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    @discardableResult func addBordersColored(
                edges: UIRectEdge,
                inset: CGFloat = 0.0,
                thickness: CGFloat = 1.0,
                alpha: CGFloat = 1.0) -> [UIView] {
        return addBorders(edges: edges, color: UIViewBorder.appearance().backgroundColor ?? UIColor.clear, inset: inset, thickness: thickness, alpha: alpha)
    }
    func removeBorders(){
        self.subviews.forEach({
            if $0 is UIX3CustomBorderView {
                $0.removeFromSuperview()
            }
        })
        
    }
    @discardableResult func addBorders(
                edges: UIRectEdge,
                color: UIColor,
                inset: CGFloat = 0.0,
                thickness: CGFloat = 1.0,
                alpha: CGFloat = 1.0) -> [UIView] {
        var borders = [UIView]()
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIX3CustomBorderView(frame: .zero)
            border.backgroundColor = color
            border.alpha = alpha
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: ["inset": inset, "thickness": thickness], views: ["border": border]) })
            borders.append(border)
            return border
        }
        removeBorders()
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        return borders
    }
    func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    func setRoundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1, color: UIColor) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    func getContraint(attribute: NSLayoutConstraint.Attribute?, relation: NSLayoutConstraint.Relation?, isActive: Bool = true) -> NSLayoutConstraint? {
        return self.getContraints(attribute: attribute, relation: relation, isActive: isActive).first
    }
    func getContraints(attribute: NSLayoutConstraint.Attribute?, relation: NSLayoutConstraint.Relation?, isActive: Bool = true) -> [NSLayoutConstraint] {
        return self.constraints.filter({ _constraint in
            return (!isActive || _constraint.isActive) && _constraint.firstAttribute == attribute && (relation == nil || _constraint.relation == relation  )
        })
    }
    func setBorderRadius(_ value: CGFloat) {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = value
    }
}
public extension UIView {
    @objc var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
