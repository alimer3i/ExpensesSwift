//
//  FAQTableViewCell.swift
//  SandS
//
//  Created by Ali Merhie on 13/10/24.
//

import UIKit

class ExpenseTableViewCell: TableCellView<ExpenseTableCellViewModel> {
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Actions
    
    //MARK: - Functions
    func setUp(title: String, amount: String, type: TransactionTypeEnum, tag: TransactionTagEnum, date: String) {
        titleLabel.text = title
        tagLabel.text = tag.rawValue
        dateLabel.text = date
        amountLabel.text = "\(type == .income ? "+" : "-") $\(amount)"
        amountLabel.textColor = type == .income ? .main_green : .main_red
        tagImageView?.image = tag.getImage()
        
    }
}
