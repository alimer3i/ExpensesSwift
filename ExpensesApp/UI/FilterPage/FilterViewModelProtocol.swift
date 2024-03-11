//
//  Protocols.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

enum FilterPageRoute {
    case back
}

protocol FilterViewModelProtocol  {
    //MARK: - Properties
    var setupTypes: PassthroughSubject<[String], Never> { get set }
    var setupTags: PassthroughSubject<[String], Never> { get set }
    var updateDesc: PassthroughSubject<String, Never> { get set }
    var filterRouteSubject: PassthroughSubject<FilterPageRoute, Never> { get set }
    var selectedType: String { get set }
    var selectedTag: String { get set }
    func applyClicked()
    func fetchData()
    
    // MARK: - Methods
}

protocol FilterViewControllerProtocol {
    var viewModel: FilterViewModelProtocol? { set get }
}
