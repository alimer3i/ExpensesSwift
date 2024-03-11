//
//  ForgetOtpVM.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/7/21.
//

import Foundation
import Combine

class AddExpenseVM: BaseVM,
                    AddExpenseViewModelProtocol {
    
    var setupTypes = PassthroughSubject<[String], Never>()
    var setupTags = PassthroughSubject<[String], Never>()
    var updateDesc = PassthroughSubject<String, Never>()
    var selectedType: TransactionTypeEnum = .income
    var selectedTag: TransactionTagEnum = .transport
    
    var addExpenseRouteSubject = PassthroughSubject<AddExpensePageRoute, Never>()

    override init() {
        super.init()
        bindUsecaseResult()
    }
    
    func fetchData(){
        var types: [String] = []
        for key in TransactionTypeEnum.allCases {
            types.append(key.rawValue)
        }
        setupTypes.send(types)
        
        var tags: [String] = []
        for key in TransactionTagEnum.allCases {
            tags.append(key.rawValue)
        }
        setupTags.send(tags)
    }
    private func bindUsecaseResult() {
        
    }
    func addClicked(title: String, amountStr: String, note: String, occuredDate: Date){
        
        if title.isEmpty || title == "" {
            showAlert(Alert(title: "Missing Field", body: "Enter Title"))
            return
        }
        if amountStr.isEmpty || amountStr == "" {
            showAlert(Alert(title: "Missing Field", body: "Enter Amount"))
            return
        }
        guard let amount = Double(amountStr) else {
            showAlert(Alert(title: "Error", body: "Enter valid number"))
            return
        }
        guard amount >= 0 else {
            showAlert(Alert(title: "Error", body: "Amount can't be negative"))
            return
        }
        guard amount <= 1000000000 else {
            showAlert(Alert(title: "Error", body: "Enter a smaller amount"))
            return
        }
        CoreDataExpensesHelper.shared.addNewExpenseData(selectedType: selectedType, title: title, tag: selectedTag, occuredOn: occuredDate, note: note, amount: amount)
        addExpenseRouteSubject.send(.back)
        
    }
    
}
