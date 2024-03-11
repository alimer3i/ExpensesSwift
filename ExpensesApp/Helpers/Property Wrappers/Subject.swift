//
//  Subject.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

@propertyWrapper
public struct Subject<T> {
    //MARK: - Properties
    private let passthrough = PassthroughSubject<T?, Never>()
    private let currentValue = CurrentValueSubject<T?, Never>(nil)
    private var current = false
    //MARK: - Initializers
    public init() {
    }
    public init(wrappedValue: T?) {
        current = true
        self.currentValue.value = wrappedValue
    }
    //MARK: - Wrapper
    public var wrappedValue: T? {
        get {
            if current {
                return currentValue.value
            }else {
                return nil
            }
        }
        nonmutating set {
            if current {
                currentValue.value = newValue
            }else {
                passthrough.send(newValue)
            }
        }
    }
    public var projectedValue: AnyPublisher<T, Never> {
        get {
            if current {
                return currentValue
                    .compactMap({$0})
                    .eraseToAnyPublisher()
            }else {
                return passthrough
                    .compactMap({$0})
                    .eraseToAnyPublisher()
            }
        }
    }
}
