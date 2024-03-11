//
//  ReportView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

class ReportView: UIView {
    //MARK: - Outlets
    
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var expenseTitleLabel: UILabel!
    @IBOutlet weak var incomeTitleLabel: UILabel!
    @IBOutlet weak var incomeValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var expenseValueLabel: UILabel!
    
    //MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        totalTitleLabel.text = "TOTAL BALANCE"
        incomeTitleLabel.text = "TOTAL INCOME"
        expenseTitleLabel.text = "TOTAL EXPENSE"
        
    }
        
    //MARK: - Functions
    func setUp(total: String, expense: String, income: String) {
        totalValueLabel.text = total
        incomeValueLabel.text = income
        expenseValueLabel.text = expense
    }

}
