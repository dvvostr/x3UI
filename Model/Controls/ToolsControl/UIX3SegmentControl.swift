import UIKit

open class UIX3SegmentControl: UISegmentedControl {
    @IBInspectable open var cornerRadius: CGFloat = 10 {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open override var tintColor: UIColor?  {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open override var backgroundColor: UIColor?  {
        didSet {
////            self.setBackgroundImage(self.backgroundImage(for: .normal, barMetrics: .default)?.alpha(0.0), for: .normal, barMetrics: .default)
//            let tintColorImage = UIImage(color: .white, size: CGSize(width: 120, height: 32))
//            setBackgroundImage(tintColorImage, for: .normal, barMetrics: .default)
//            self.layer.backgroundColor = (UIColor.backgroundColor ?? .clear).CGColor;
//            setBackgroundImage(UIImage(color: self.backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            self.invalidate()
        }
    }
    @IBInspectable open var foregroundColor: UIColor?  {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var indicatorColor: UIColor?  {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var foregroundHeight: CGFloat = -1 {
        didSet {
            self.invalidate()
        }
    }
    @IBInspectable open var font: UIFont?  {
        didSet {
            self.invalidate()
        }
    }
    open override func layoutSubviews(){
        super.layoutSubviews()
        self.invalidate()
    }
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    lazy private var indicatorView: UIView? = {
        let _view = UIView()
        let _index = numberOfSegments
        if subviews.indices.contains(_index), let _foregroundImageView = subviews[numberOfSegments] as? UIImageView {
            _foregroundImageView.addSubview(_view)
            _view.anchor(nil, left: _foregroundImageView.leftAnchor, bottom: _foregroundImageView.bottomAnchor, right: _foregroundImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 4)
        }
        return _view
    }()
    private func invalidate(){
        if let _font = self.font, let _color1 = self.foregroundColor, let _color2 = self.tintColor {
            let _segmentStringSelected: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : _font,
                NSAttributedString.Key.foregroundColor : _color1 // selected
            ]
            let _segmentStringHighlited: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : _font,
                NSAttributedString.Key.foregroundColor : _color2 // normal
            ]
            setTitleTextAttributes(_segmentStringHighlited, for: .normal)
            setTitleTextAttributes(_segmentStringSelected, for: .selected)
            setTitleTextAttributes(_segmentStringHighlited, for: .highlighted)
        }
        layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = self.foregroundHeight > 0 ? UIColor.clear : self.tintColor
        } else {
            super.tintColor = self.foregroundHeight > 0 ? UIColor.clear : self.tintColor
        }
        super.backgroundColor = self.foregroundHeight > 0 ? UIColor.clear : self.backgroundColor
        
        let _maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        self.setBorderRadius(self.foregroundHeight > 0 ? 0 : self.cornerRadius)
        layer.maskedCorners = _maskedCorners
        let _index = numberOfSegments
        if subviews.indices.contains(_index), let _foregroundImageView = subviews[numberOfSegments] as? UIImageView {
            _foregroundImageView.image = UIImage()
            _foregroundImageView.clipsToBounds = true
            _foregroundImageView.layer.masksToBounds = true
            _foregroundImageView.backgroundColor = self.foregroundHeight > 0 ? UIColor.clear : self.tintColor
            self.indicatorView?.backgroundColor = self.foregroundHeight > 0 ? self.indicatorColor : UIColor.clear
            self.indicatorView?.setBorderRadius(self.foregroundHeight / 2)
            _foregroundImageView.layer.cornerRadius = 0
            _foregroundImageView.layer.maskedCorners = _maskedCorners
        }
    }
  
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
