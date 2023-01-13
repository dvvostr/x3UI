import UIKit
import SwiftUI

/********************************************************/
extension UIColor{
    public static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    public func getAlphaColor(_ alpha: CGFloat) -> UIColor{
        var _return = self, _red : CGFloat = 0, _green : CGFloat = 0, _blue : CGFloat = 0, _alpha: CGFloat = 0
        if self.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha) {
            _return = UIColor(red: CGFloat(_red), green: CGFloat(_green), blue: CGFloat(_blue), alpha: alpha)
        } else {
        }
        return _return
    }
    public static func fromHex(rgbValue:UInt32, alpha: Double=1.0) -> UIColor {
        let _red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0,
            _green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0,
            _blue = CGFloat(rgbValue & 0xFF)/256.0;
        return UIColor(red: _red, green: _green, blue: _blue, alpha:CGFloat(alpha))
    }
    public static func fromHex(hexString: String) -> UIColor? {
        if (hexString.count > 7 || hexString.count < 7) {
            return nil
        } else {
            let hexInt = Int(String(hexString[hexString.index(hexString.startIndex, offsetBy: 1)...]), radix: 16)
            if let hex = hexInt {
                let components = (
                    R: CGFloat((hex >> 16) & 0xff) / 255,
                    G: CGFloat((hex >> 08) & 0xff) / 255,
                    B: CGFloat((hex >> 00) & 0xff) / 255
                )
                return UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1)
            } else {
                return nil
            }
        }
    }
    public func invert(by percentage: CGFloat = 30.0) -> UIColor? {
        var _return: UIColor? = self, _red : CGFloat = 0, _green : CGFloat = 0, _blue : CGFloat = 0, _alpha: CGFloat = 0
        if self.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha) {
            if ((_red + _green + _blue) / 3) > 0.5{
                _return = _return?.darker(by: percentage)
            } else {
                _return = _return?.lighter(by: percentage)
            }
        } else {
        }
        return _return
    }
    public func oposite() -> UIColor? {
        var _return = self, _red : CGFloat = 0, _green : CGFloat = 0, _blue : CGFloat = 0, _alpha: CGFloat = 0;
        if self.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha) {
            if (_red > 0.5 || _green > 0.5 || _blue > 0.5) {
                _return = UIColor.black
            } else {
                _return = UIColor.white
            }
        } else {
        }
        return _return
    }
    public func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var _red: CGFloat = 0, _green: CGFloat = 0, _blue: CGFloat = 0, _alpha: CGFloat = 0;
        if(self.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha)){
            return UIColor( red: min(_red + percentage / 100, 1.0), green: min(_green + percentage / 100, 1.0), blue: min(_blue + percentage / 100, 1.0), alpha: _alpha)
        } else {
            return nil
        }
    }
    public func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    public func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    public func RGBtoCMYK(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        if r == 0, g == 0, b == 0 { return (0, 0, 0, 1) }
        var c = 1 - r, m = 1 - g, y = 1 - b
        let minCMY = min(c, m, y)
        c = (c - minCMY) / (1 - minCMY)
        m = (m - minCMY) / (1 - minCMY)
        y = (y - minCMY) / (1 - minCMY)
        return (c, m, y, minCMY)
    }
    func CMYKtoRGB(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        return ((1 - c) * (1 - k), (1 - m) * (1 - k), (1 - y) * (1 - k))
    }
    func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(r: ciColor.red, g: ciColor.green, b: ciColor.blue)
        let kVal = originCMYK.k > 0.3 ? originCMYK.k - 0.2 : originCMYK.k + 0.2
        let tintRGB = CMYKtoRGB(c: originCMYK.c, m: originCMYK.m, y: originCMYK.y, k: kVal)
        return UIColor(red: tintRGB.r, green: tintRGB.g, blue: tintRGB.b, alpha: 1.0)
    }
}


public extension UIColor {
    var suiColor: Color { Color(self) }
}

public extension UIColor {
    var HEX: String {
        get {
            let components = self.cgColor.components
            let r: CGFloat = components?[0] ?? 0.0
            let g: CGFloat = components?[1] ?? 0.0
            let b: CGFloat = components?[2] ?? 0.0

            let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
            return hexString
        }
     }
//    static func fromHEX(_ value: String) -> UIColor {
//        var colorString = value.trimmingCharacters(in: .whitespacesAndNewlines)
//        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
//        let alpha: CGFloat = 1.0
//        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
//        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
//        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)
//
//        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
//        return color
//    }
//
//    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
//
//        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
//        let endIndex = colorString.index(startIndex, offsetBy: length)
//        let subString = colorString[startIndex..<endIndex]
//        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
//        var hexComponent: UInt32 = 0
//
//        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
//            return 0
//        }
//        let hexFloat: CGFloat = CGFloat(hexComponent)
//        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
//        print(floatValue)
//        return floatValue
//    }
}
