//
//  TargetFontConfigurations.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

struct TargetFontConfiguration: FontConfigurable {
    var font: TargetFont
    var weight: AppWeight
    var target: AppTargets?
    var size: CGFloat
    var fontString: String {
        return font.currentFont.rawValue + weight.string
    }
    var configuration: TargetFontConfiguration {
        return self
    }
    func with(target: AppTargets?) -> Self {
        return TargetFontConfiguration(font: font, weight: weight, target: target, size: size)
    }
    func with(size: CGFloat) -> Self {
        return TargetFontConfiguration(font: font, weight: weight, target: target, size: size)
    }
}

protocol FontConfigurable {
    var configuration: TargetFontConfiguration {get}
}

func with(_ configuration: FontConfigurable, size: CGFloat, for target: AppTargets? = nil) -> TargetFontConfiguration {
    return configuration.configuration
        .with(target: target)
        .with(size: size)
}

@resultBuilder
struct FontBuilder {
    static func buildBlock(_ parts: TargetFontConfiguration...) -> [TargetFontConfiguration] {
        return parts
    }
}

