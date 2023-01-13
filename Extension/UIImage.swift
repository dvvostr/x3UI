import UIKit

public extension UIImage {
    var withRenderingModeTemplate: UIImage {
        get {
            return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
    }
    var withRenderingOriginal: UIImage {
        get {
            return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        }
    }
//*************************//
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    convenience init?(sourceNamed: String, bgColor: UIColor, size: CGFloat, bgAlpha: CGFloat, imgAlpha: CGFloat, insetDimen: CGFloat = 0) {
        guard let _img = UIImage(named: sourceNamed)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: size, height: size)).alpha(imgAlpha).withInsets(insetDimen: insetDimen) else {
            return nil
        }
        let _rect = CGRect(x: 0, y: 0, width: size, height: size)
        let _size = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(_size, true, 0)
        let _context = UIGraphicsGetCurrentContext()
        _context!.setFillColor(bgColor.withAlphaComponent(bgAlpha).cgColor)
        _context!.fill(_rect)
        _img.draw(in: _rect, blendMode: .normal, alpha: 1)
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = _image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    convenience init?(sourceNamed: String, size: CGFloat, alpha: CGFloat, insetDimen: CGFloat = 0) {
        guard let _img = UIImage(named: sourceNamed)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: size, height: size)).alpha(alpha).withInsets(insetDimen: insetDimen) else {
            return nil
        }
        let _rect = CGRect(x: 0, y: 0, width: size, height: size)
        let _size = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(_size, true, 0)
        let _context = UIGraphicsGetCurrentContext()
        _context!.fill(_rect)
        _img.draw(in: _rect, blendMode: .normal, alpha: 1)
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = _image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    convenience init?(url: URL) {
        guard let _data = try? Data(contentsOf: url) else { return nil }
        self.init(data: _data)
    }
    convenience init?(base64: String?) {
        guard let _base64 = base64 else { return nil }
        guard let _data = Data(base64Encoded: _base64, options: .ignoreUnknownCharacters) else { return nil }
        self.init(data: _data)
    }
    func asBase64String() -> String? {
        guard let _data = self.pngData() else { return nil }
        return _data.base64EncodedString(options: .lineLength64Characters).filter{ !"\r\n".contains($0) }
    }
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        let newSize: CGSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    static func colored(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func colored(_ color: UIColor?) -> UIImage? {
        if let newColor = color {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            newColor.setFill()
            context.fill(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        return self
    }
    func drawOnImage(startingImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        startingImage.draw(at: CGPoint.zero)
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return _image!
    }
    func withInsets(insetDimen: CGFloat) -> UIImage {
        return withInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    func withInset(insets: CGFloat) -> UIImage {
        return self.withInset(insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }
    func withInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    class func withSolidColor(_ color: UIColor?, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if color != nil {
            color!.setFill()
        } else {
            UIColor.black.setFill()
        }
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    class func fromScreen() -> UIImage {
        let keyWindow = UIApplication.keyWindow
        let rect = keyWindow?.bounds
        UIGraphicsBeginImageContextWithOptions((rect?.size)!, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        keyWindow?.layer.render(in: context!)
        let capturedScreen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedScreen!;
    }
    
   
}
