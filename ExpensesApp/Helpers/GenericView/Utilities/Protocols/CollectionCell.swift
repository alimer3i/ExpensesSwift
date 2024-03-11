//
//  CollectionCell.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public protocol CollectionCell: NibCreatable, Configurable {
}

//MARK: - Configurable
extension CollectionCell {
    public static func configure<ViewModel: CellViewModel>(collection: CollectionableView, viewModel: ViewModel) -> ViewModel.CellType {
        collection.register(nib, for: identifier)
        let cell = collection.dequeueReusableCell(with: identifier, for: viewModel.indexPath) as! ViewModel.CellType
        if let celly = cell as? TableCellView<ViewModel> {
            celly.viewModel = viewModel
        }else if let celly = cell as? CollectionCellView<ViewModel> {
            celly.viewModel = viewModel
        }
        viewModel.configure(cell: cell)
        return cell
    }
}

//MARK: - UITableViewCell
extension UITableViewCell: CollectionCell {
}

//MARK: - UICollectionViewCell
extension UICollectionViewCell: CollectionCell {
}
