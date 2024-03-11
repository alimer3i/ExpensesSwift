//
//  ExpenseModel.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
public class ExpenseModel {
     public var createdAt: Date?
     public var updatedAt: Date?
     public var type: String?
     public var title: String?
     public var tag: String?
     public var occuredOn: Date?
     public var note: String?
     public var amount: Double
    
    init(item: ExpenseCD){
        self.createdAt = item.createdAt
        self.updatedAt = item.updatedAt
        self.type = item.type
        self.title = item.title
        self.tag = item.tag
        self.occuredOn = item.occuredOn
        self.note = item.note
        self.amount = item.amount

    }
}
