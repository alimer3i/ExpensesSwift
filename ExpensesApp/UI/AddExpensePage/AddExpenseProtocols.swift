//
//  Protocols.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

enum AddExpensePageRoute {
    case back
}

protocol AddExpenseViewModelProtocol  {
    //MARK: - Properties
    var setupTypes: PassthroughSubject<[String], Never> { get set }
    var setupTags: PassthroughSubject<[String], Never> { get set }
    var updateDesc: PassthroughSubject<String, Never> { get set }
    var addExpenseRouteSubject: PassthroughSubject<AddExpensePageRoute, Never> { get set }
    var selectedType: TransactionTypeEnum { get set }
    var selectedTag: TransactionTagEnum { get set }
    func addClicked(title: String, amountStr: String, note: String, occuredDate: Date)
    func fetchData()
    
    // MARK: - Methods
}

protocol AddExpenseViewControllerProtocol {
    var viewModel: AddExpenseViewModelProtocol? { set get }
}
