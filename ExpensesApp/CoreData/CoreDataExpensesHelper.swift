//
//  CoreDataHelper.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/9/24.
//

import UIKit
import CoreData

class CoreDataExpensesHelper {
    static let shared = CoreDataExpensesHelper()
    
    private lazy var mainManagedObjectContext: NSManagedObjectContext = {
        return AppDelegate.shared.persistentContainer.viewContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainManagedObjectContext
        return privateContext
    }()
    
    func getAllExpenseData(type: String, tag: String, sortBy: ExpenseCDSort = .occuredOn, ascending: Bool = false, filterTime: ExpenseCDFilterTime = .all) -> [ExpenseModel] {
        let request: NSFetchRequest<ExpenseCD> = NSFetchRequest(entityName: "ExpenseCD") as! NSFetchRequest<ExpenseCD>
        let sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
        var predicate: NSPredicate!

        if type != "all"  && tag != "all"{
            predicate = NSPredicate(format: "type == %@ AND tag == %@", type, tag)
            request.predicate = predicate
        }else if type != "all" {
            predicate = NSPredicate(format: "type == %@", type)
            request.predicate = predicate
        }else if tag != "all"{
            predicate = NSPredicate(format: "tag == %@", tag)
            request.predicate = predicate
        }

        
//        if filterTime == .week {
//            let startDate: NSDate = Date().getLast7Day()! as NSDate
//            let endDate: NSDate = NSDate()
//            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
//            request.predicate = predicate
//        } else if filterTime == .month {
//            let startDate: NSDate = Date().getLast30Day()! as NSDate
//            let endDate: NSDate = NSDate()
//            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
//            request.predicate = predicate
//        }
        request.sortDescriptors = [sortDescriptor]
        var expenses = [ExpenseCD]()

        do{
            expenses =  try CoreDataExpensesHelper.shared.mainManagedObjectContext.fetch(request)
        } catch {
            print("Error fetching context , \(error)")
        }
        var result: [ExpenseModel] = []
        for expense in expenses {
            result.append(ExpenseModel(item: expense))
        }
        return result
    }
     func addNewExpenseData(selectedType: TransactionTypeEnum, title: String, tag: TransactionTagEnum, occuredOn: Date, note: String, amount: Double){
        let expense = ExpenseCD(context: CoreDataExpensesHelper.shared.mainManagedObjectContext)

        expense.updatedAt = Date()
        expense.createdAt = Date()
        expense.type = selectedType.rawValue
        expense.title = title
        expense.tag = tag.rawValue
        expense.occuredOn = occuredOn
        expense.note = note
        expense.amount = amount
        do {
            try CoreDataExpensesHelper.shared.mainManagedObjectContext.save()
            NotificationCenter.default.post(name: .expensesUpdated, object: nil)

        } catch {
            print("\(error)")
        }
    }
}
