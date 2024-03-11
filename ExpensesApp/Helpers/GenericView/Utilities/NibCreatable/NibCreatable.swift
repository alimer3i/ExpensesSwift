//
//  NibCreatable.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public protocol NibCreatable: AnyObject {
    static var nib: UINib {get}
    static var nibBundle: Bundle? {get}
    static var nibName: String {get}
    static func instance() -> Self
}
