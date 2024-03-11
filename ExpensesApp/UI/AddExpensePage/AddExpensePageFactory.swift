//
//  OtpPageFactory.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit

class AddExpensePageFactory {
    static func assemble() -> UIViewController? {
        
        let viewModel = AddExpenseVM()
        let addExpenseView = AddExpenseViewController(VM: viewModel)
      
        return addExpenseView
    }
}
