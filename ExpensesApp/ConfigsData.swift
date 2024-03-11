//
//  Configs.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/9/24.
//

import Foundation
import UIKit

enum TransactionTypeEnum: String, CaseIterable {
    case income = "income"
    case expense = "expense"

   }

enum TransactionTagEnum: String, CaseIterable {
    case transport
    case food
    case housing
    case insurance
    case medical
    case savings
    case personal
    case entertainment
    case others
    case utilities
    
    func getImage() -> UIImage {
        switch self {
        case .transport:
            UIImage(named: "trans_type_transport")!
        case .food:
            UIImage(named: "trans_type_food")!
        case .housing:
            UIImage(named: "trans_type_housing")!
        case .insurance:
            UIImage(named: "trans_type_insurance")!
        case .medical:
            UIImage(named: "trans_type_medical")!
        case .savings:
            UIImage(named: "trans_type_savings")!
        case .personal:
            UIImage(named: "trans_type_personal")!
        case .entertainment:
            UIImage(named: "trans_type_entertainment")!
        case .others:
            UIImage(named: "trans_type_others")!
        case .utilities:
            UIImage(named: "trans_type_utilities")!
        }
    }

   }
