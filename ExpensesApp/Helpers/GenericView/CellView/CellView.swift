//
//  TableViewCell.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

open class TableCellView<ViewModel: CellViewModel>: UITableViewCell {
//MARK: - Properties
    open var viewModel: ViewModel!
//MARK: - Lifecycle
}

open class CollectionCellView<ViewModel: CellViewModel>: UICollectionViewCell {
//MARK: - Properties
    open var viewModel: ViewModel!
//MARK: - Lifecycle
}
