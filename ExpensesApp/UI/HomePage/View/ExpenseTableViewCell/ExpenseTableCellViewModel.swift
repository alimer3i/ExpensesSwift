//
//  FAQTableCellViewModel.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

class ExpenseTableCellViewModel: CellViewModel {
//MARK: - Properties
    var indexPath: IndexPath!
    var item: ExpenseModel?
    var cellType = ExpenseTableViewCell.self
//MARK: - Functions
    func configure(cell: ExpenseTableViewCell) {
        guard let item else {return}
        cell.setUp(title: item.title ?? "", amount: String(format: "%.2f", item.amount), type: TransactionTypeEnum(rawValue: item.type!) ?? .expense, tag: TransactionTagEnum(rawValue: item.tag!) ?? .transport, date: item.occuredOn?.toDateString() ?? "N/A")
    }
    func selected() {
//        item?.isExpanded.toggle()
    }
    static func initialize() -> ExpenseTableCellViewModel {
        return ExpenseTableCellViewModel()
    }
}
