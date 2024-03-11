//
//  LocalizationExtensions.swift
//  PalmReading
//
//  Created by Ali Merhie on 9/23/19.
//  Copyright © 2019 Monty Mobile. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    private static let _preventRTL = ObjectAssociation<Bool>()
    @IBInspectable var preventRTL: Bool {
        get { return UIView._preventRTL[self] ?? false }
        set { UIView._preventRTL[self] = newValue }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if preventRTL {
            semanticContentAttribute = .forceLeftToRight
        } else {
            semanticContentAttribute = AppSettings.currentLanguageIsRTL ? .forceRightToLeft : .forceLeftToRight
        }
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if textAlignment != .center, !self.preventRTL {
            self.textAlignment = AppSettings.currentLanguageIsRTL ? .right : .left
        }
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        adjustsFontSizeToFitWidth = true
        if textAlignment != .center, !self.preventRTL {
            self.textAlignment = AppSettings.currentLanguageIsRTL ? .right : .left
        }
    }
}
extension UIImageView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if  !self.preventRTL {
            self.transform = AppSettings.currentLanguageIsRTL ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
            
        }
    }
}
extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if  !self.preventRTL {
            self.imageView?.transform = AppSettings.currentLanguageIsRTL ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
            self.semanticContentAttribute = AppSettings.currentLanguageIsRTL ? .forceRightToLeft : .forceLeftToRight
        }
    }
}

