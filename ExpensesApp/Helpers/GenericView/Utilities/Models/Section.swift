//
//  Section.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

public struct Section {
//MARK: - Properties
    public var rows: Cells
//MARK: - Initializers
    public init(rows: Cells) {
        self.rows = rows
    }
}

public extension Array where Element == any CellViewModel {
    func section() -> Section {
        Section(rows: self)
    }
}

public extension Array where Element == Section {
    var empty: Bool {
        return reduce(into: Cells()) { partialResult, element in
            partialResult.append(contentsOf: element.rows)
        }.isEmpty
    }
}
