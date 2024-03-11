//
//  UseCase.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

protocol UseCase {
    associatedtype InputType
    associatedtype ReponseOutputType
    associatedtype ErrorType: Error
    
    var returnedResult: PassthroughSubject<ApiResult<ReponseOutputType>, ErrorType> { get set }
    func execute(input: InputType) async
}
