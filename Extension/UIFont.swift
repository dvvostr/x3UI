import UIKit

public enum UIFontType {
    case regular
    case italic
}
public enum UIFontKind {
    case regular
    case black
    case bold
    case book
    case extralight
    case hairline
    case heavy
    case light
    case medium
    case thin
}

public extension UIFont {
  func withWeight(_ weight: UIFont.Weight) -> UIFont {
    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
      UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: newDescriptor, size: pointSize)
  }
}
