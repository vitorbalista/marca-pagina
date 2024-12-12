import SwiftUI

enum ColorAsset {
    case blue
    case pink
    case red

    var primary: Color {
        switch self {
        case .blue: return Color("primary-blue")
        case .pink: return Color("primary-pink")
        case .red: return Color("primary-red")
        }
    }

    var secondary: Color {
        switch self {
        case .blue: return Color("secondary-blue")
        case .pink: return Color("secondary-pink")
        case .red: return Color("secondary-red")
        }
    }

    var tertiary: Color {
        switch self {
        case .blue: return Color("tertiary-blue")
        case .pink: return Color("tertiary-pink")
        case .red: return Color("tertiary-red")
        }
    }
}
