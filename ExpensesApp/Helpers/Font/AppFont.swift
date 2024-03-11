//
//  AppFont.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

enum AppFont: String {
    case outfit = "Outfit-"
    case rubik = "Rubik-"
    case notoKufiArabic = "NotoKufiArabic-"
}

enum AppWeight {
    case ultraThin, thin, ultraLight, light, regular, medium, semiBold, bold, extraBold, heavy, black
    var string: String {
        switch self {
            case .ultraThin:
                return "UltraThin"
            case .thin:
                return "Thin"
            case .ultraLight:
                return "UltraLight"
            case .light:
                return "Light"
            case .regular:
                return "Regular"
            case .medium:
                return "Medium"
            case .semiBold:
                return "SemiBold"
            case .bold:
                return "Bold"
            case .extraBold:
                return "ExtraBold"
            case .heavy:
                return "Heavy"
            case .black:
                return "Black"
        }
    }
}
