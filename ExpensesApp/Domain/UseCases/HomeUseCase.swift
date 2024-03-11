//
//  FAQUseCase.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

class HomeUseCase: UseCase {
    typealias InputType = (type: String, tag: String)
    typealias ReponseOutputType = [ExpenseModel]
    typealias ErrorType = Never
    
    var returnedResult =  PassthroughSubject<ApiResult<[ExpenseModel]>, Never>()

    func execute(input: (type: String, tag: String)) async {
        let expenses = CoreDataExpensesHelper.shared.getAllExpenseData(type: input.type, tag: input.tag)
        returnedResult.send(.success(value: expenses))
    }
}
