//
//  CellViewModel.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//
import UIKit

public protocol CellViewModel: AnyObject, Iterable {
    associatedtype CellType: Configurable & CollectionCell
    var height: CGFloat? {get}
    var size: CGSize? {get}
    var spacing: CGFloat? {get}
    var indexPath: IndexPath! {get set}
    var insets: UIEdgeInsets? {get}
    var cellType: CellType.Type {get}
    func configure(cell: CellType)
}

//MARK: - Default
public extension CellViewModel {
    var height: CGFloat? {
        return nil
    }
    var size: CGSize? {
        return nil
    }
    var spacing: CGFloat? {
        return nil
    }
    var insets: UIEdgeInsets? {
        return nil
    }
}

public typealias Cells = [Cell]
public typealias Cell = any CellViewModel
