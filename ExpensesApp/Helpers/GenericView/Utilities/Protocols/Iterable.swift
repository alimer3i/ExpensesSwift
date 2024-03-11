//
//  Iterable.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

public protocol Iterable: AnyObject {
    associatedtype Super
    static func iterate<Collection: RandomAccessCollection>(using data: Collection, for keyPath: ReferenceWritableKeyPath<Super, Collection.Element>) -> [Super]
    static func iterate(to count: Int, map: @escaping (Super, Int) -> Void) -> [Super]
    static func iterate(to count: Int, map: @escaping (Int) -> Super) -> [Super]
    static func initialize() -> Super
}

//MARK: - Iterable
public extension Iterable {
    static func iterate<Collection: RandomAccessCollection>(using data: Collection, for keyPath: ReferenceWritableKeyPath<Super, Collection.Element>) -> [Super] {
        return data.reduce(into: [Super]()) { partialResult, item in
            let newViewModel = initialize()
            newViewModel[keyPath: keyPath] = item
            partialResult.append(newViewModel)
        }
    }
    static func iterate(to count: Int, map: @escaping (Super, Int) -> Void) -> [Super] {
        return (0..<count).indices.reduce(into: [Super]()) { partialResult, index in
            let newViewModel = initialize()
            map(newViewModel, index)
            partialResult.append(newViewModel)
        }
    }
    static func iterate(to count: Int, map: @escaping (Int) -> Super) -> [Super] {
        return (0..<count).indices.reduce(into: [Super]()) { partialResult, index in
            partialResult.append(map(index))
        }
    }
}

extension Array where Element: Iterable {
    @inlinable func with<T>(_ map: (Int) throws -> T, for keyPath: ReferenceWritableKeyPath<Element, T>) rethrows -> Self {
        try indices.forEach { index in
            self[index][keyPath: keyPath] = try map(index)
        }
        return self
    }
    @inlinable func with<T>(_ map: () throws -> T, for keyPath: ReferenceWritableKeyPath<Element, T>) rethrows -> Self {
        try indices.forEach { index in
            self[index][keyPath: keyPath] = try map()
        }
        return self
    }
    @inlinable func with<T>(_ item: T, for keyPath: ReferenceWritableKeyPath<Element, T>) -> Self {
        let new = self
        indices.forEach { index in
            new[index][keyPath: keyPath] = item
        }
        return new
    }
}
