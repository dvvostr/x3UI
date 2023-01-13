import UIKit


open class UIX3CustomControl {
    public struct Defaults {
        public struct Color {
            public static var background: UIColor? = UIColor.clear
            public static var foreground: UIColor? = UIColor.darkText
            public static var border: UIColor? = UIColor.darkText
            public static var tint: UIColor? = UIColor.darkText
            public static var text: UIColor? = UIColor.darkText

        }
        public static var cornerRadius: CGFloat = 12
        public static var borderWidth: CGFloat = 1.0
        public static var textFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var inputFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var smallFont: UIFont = UIFont.systemFont(ofSize: 12)
    }
}
