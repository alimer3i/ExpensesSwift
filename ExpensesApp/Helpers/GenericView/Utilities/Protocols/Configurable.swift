//
//  Configurable.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public protocol Configurable: AnyObject {
    static func configure<ViewModel: CellViewModel>(collection: CollectionableView, viewModel: ViewModel) -> ViewModel.CellType
}
