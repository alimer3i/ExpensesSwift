//
//  UINavigationController+Extension.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func set(controllers: [UIViewController]) {
        self.setViewControllers(controllers, animated: false)
    }
    
    func set(presentation style: UIModalPresentationStyle) {
        self.modalPresentationStyle = style
    }
    
}
