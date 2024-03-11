//
//  Action.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

@propertyWrapper
public struct Action {
    //MARK: - Properties
    var action: () -> Void {
        return {
            passthrough.send(true)
        }
    }
    private let passthrough = PassthroughSubject<Bool, Never>()
    //MARK: - Initializers
    public init() {
    }
    //MARK: - Wrapper
    public var wrappedValue: () -> Void {
        get {
            return action
        }
        nonmutating set {
        }
    }
    public var projectedValue: AnyPublisher<Bool, Never> {
        return passthrough
            .eraseToAnyPublisher()
    }
}
