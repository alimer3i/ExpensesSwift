//
//  UIViewController+NibCreatable.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

extension UIViewController: NibCreatable {
    @objc final public class var nib: UINib {
        let name = Self.nibName
        let bundle = Self.nibBundle
        return UINib(nibName: name, bundle: bundle)
    }
    @objc public class var nibBundle: Bundle? {
        return Bundle(for: self)
    }
    @objc public class var nibName: String {
        return "\(self)"
    }
    @objc final public class func instance() -> Self {
        return Self.init(nibName: nibName, bundle: nibBundle)
    }
}
