//
//  StringExtension.swift
//  PalmReading
//
//  Created by Ali Merhie on 9/13/19.
//  Copyright © 2019 Monty Mobile. All rights reserved.
//

import Foundation
import UIKit

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
    func localizedWithParameters(_ parameters: CVarArg...) -> String
}


enum LanguageEnum: Int, CaseIterable, Codable {
    case english
    case french
    case arabic
    var instance: LanguageModel {
        switch self {
        case .english: return LanguageModel(id:"en", title: "English", isRTL: false, iconName: "GB")
        case .french: return LanguageModel(id:"fr", title: "Français", isRTL: false, iconName: "FR")
            case .arabic: return LanguageModel(id:"ar", title: "Arabic", isRTL: true, iconName: "AR")
        }
    }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localizedText(tableName: tableName)
    }
}

extension String {
    
    func localizedText(bundle: Bundle = Bundle(path: Bundle.main.path(forResource: AppSettings.selectedLanguageDefualt.instance.id, ofType: "lproj")!)!, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
    
    func localizedWithParameters(_ parameters: CVarArg...) -> String {
        return String(format: self.localizedText(), arguments: parameters)
    }
}


class LanguageModel: Codable {
//MARK: - Properties
    var id: String!
    var title: String!
    var isRTL: Bool! 
    var iconName: String!
    enum CodingKeys: CodingKey {
        case id, title, isRTL
    }
//MARK: - Initializer
    init(id: String, title: String, isRTL: Bool, iconName: String) {
        self.id = id
        self.title = title
        self.isRTL = isRTL
        self.iconName = iconName

    }
}
