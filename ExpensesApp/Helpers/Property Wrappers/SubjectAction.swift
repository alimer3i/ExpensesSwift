//
//  SubjectAction.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

@propertyWrapper
public struct SubjectAction<T> {
    //MARK: - Properties
    var action: (T) -> Void {
        return { value in
            passthrough.send(value)
        }
    }
    private let passthrough = PassthroughSubject<T, Never>()
    //MARK: - Initializers
    public init() {
    }
    //MARK: - Wrapper
    public var wrappedValue: (T) -> Void {
        get {
            return action
        }
        nonmutating set {
        }
    }
    public var projectedValue: AnyPublisher<T, Never> {
        return passthrough
            .eraseToAnyPublisher()
    }
}
