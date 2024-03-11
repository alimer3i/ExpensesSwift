//
//  UiTextFieldExtension.swift
//  CallerRate
//
//  Created by Ali Merhie on 11/26/19.
//  Copyright © 2019 Monty Mobile. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func placeholder(_ placeholderString: String? = nil, font: UIFont? = nil, color: UIColor? = nil) {
        var placeholderAttributes: [NSAttributedString.Key: Any] = [:]
        if let font {
            placeholderAttributes[.font] = font
        }
        if let color {
            placeholderAttributes[.foregroundColor] = color
        }
        attributedPlaceholder = NSAttributedString(string: (placeholder ?? placeholderString) ?? "", attributes: placeholderAttributes)
    }
}
