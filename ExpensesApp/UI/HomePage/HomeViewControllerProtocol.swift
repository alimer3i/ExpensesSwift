//
//  FAQProtocols.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

enum HomePageRoute {
    case addExpense
    case filter

}
protocol HomeViewControllerProtocol {
    var viewModel: HomeVMProtocol? { get set }

}

protocol HomeVMProtocol {
    var reloadTableViewAt: PassthroughSubject<IndexPath, Never> { get set }
    var setUpHeader: PassthroughSubject<(isDisplayed: Bool, total: String, income: String, expense: String), Never> { get set }
    var HomePageRouteSubject: PassthroughSubject<HomePageRoute, Never> { get set }
    var filterAppliedSubject: PassthroughSubject<(type: String, tag: String ), Never> { get set }
    var appliedFilter : (type: String, tag: String) { get set }
    func fetchData()
}
