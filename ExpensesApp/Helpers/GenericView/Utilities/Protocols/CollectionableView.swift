//
//  CollectionableView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public protocol CollectionableView {
    func register(_ nib: UINib?, for identifier: String)
    func dequeueReusableCell(with identifier: String, for indexPath: IndexPath) -> CollectionCell
}

//MARK: - UITableView
extension UITableView: CollectionableView {
    public func register(_ nib: UINib?, for identifier: String) {
        register(nib, forCellReuseIdentifier: identifier)
    }
    public func dequeueReusableCell(with identifier: String, for indexPath: IndexPath) -> CollectionCell {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

//MARK: - UICollectionView
extension UICollectionView: CollectionableView {
    public func register(_ nib: UINib?, for identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    public func dequeueReusableCell(with identifier: String, for indexPath: IndexPath) -> CollectionCell {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
