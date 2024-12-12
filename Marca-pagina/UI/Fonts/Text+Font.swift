import SwiftUI

enum TextStyle {
    case bold
    case boldItalic
    case italic
    case regular
}

extension Text {
    func style(_ style: TextStyle, size: CGFloat) -> some View {
        switch style {
        case .bold:
            return font(Font.custom("Atkinson Hyperlegible Bold", size: size))
        case .boldItalic:
            return font(Font.custom("Atkinson Hyperlegible Bold Italic", size: size))
        case .italic:
            return font(Font.custom("Atkinson Hyperlegible Italic", size: size))
        case .regular:
            return font(Font.custom("Atkinson Hyperlegible Regular", size: size))
        }
    }
}

extension TextField {
    func style(_ style: TextStyle, size: CGFloat) -> some View {
        switch style {
        case .bold:
            return font(Font.custom("Atkinson Hyperlegible Bold", size: size))
        case .boldItalic:
            return font(Font.custom("Atkinson Hyperlegible Bold Italic", size: size))
        case .italic:
            return font(Font.custom("Atkinson Hyperlegible Italic", size: size))
        case .regular:
            return font(Font.custom("Atkinson Hyperlegible Regular", size: size))
        }
    }
}
