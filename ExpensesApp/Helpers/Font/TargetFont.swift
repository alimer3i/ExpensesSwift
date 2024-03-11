//
//  TargetFont.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

enum TargetFont: FontConfigurable {
    case primary, secondary
    func weight(_ weight: AppWeight) -> TargetFontConfiguration {
        return TargetFontConfiguration(font: self, weight: weight, size: 17)
    }
    var configuration: TargetFontConfiguration {
        return TargetFontConfiguration(font: self, weight: .regular, size: 17)
    }
    var currentFont: AppFont {
        switch self {
            case .primary:
                switch AppTargets.target {
                    case .skeleton:
                        switch AppSettings.selectedLanguageDefualt {
                            case .arabic:
                                return .notoKufiArabic
                            default:
                                return .rubik
                        }
                    case .skeletonTarget:
                        switch AppSettings.selectedLanguageDefualt {
                            case .arabic:
                                return .outfit
                            default:
                                return .rubik
                        }
                }
            case .secondary:
                switch AppTargets.target {
                    case .skeleton:
                        switch AppSettings.selectedLanguageDefualt {
                            case .arabic:
                                return .notoKufiArabic
                            default:
                                return .outfit
                        }
                    case .skeletonTarget:
                        switch AppSettings.selectedLanguageDefualt {
                            case .arabic:
                                return .outfit
                            default:
                                return .rubik
                        }
                }
        }
    }
}
