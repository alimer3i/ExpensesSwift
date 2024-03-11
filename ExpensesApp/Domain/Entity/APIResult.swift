//
//  APIResult.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

enum ApiResult<T> {
    case success(value: T)
    case failure(ErrorResponseModel)
}
