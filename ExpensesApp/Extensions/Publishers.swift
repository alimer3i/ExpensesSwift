//
//  Publishers.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine
import UIKit
import SkeletonView

public extension Publisher where Self.Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, for object: Root) -> AnyCancellable {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
    func assign<Root: AnyObject, Provider: CancellableProvider>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, for object: Root, provider: Provider) {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }.store(in: &provider.cancellables)
    }
    func sink<Object: AnyObject>(_ object: Object, receiveValue: @escaping (Output, Object) -> Void) -> AnyCancellable {
        sink { [weak object] newValue in
            guard let object else {return}
            receiveValue(newValue, object)
        }
    }
    func sink<Object: CancellableProvider>(_ object: Object, receiveValue: @escaping (Output, Object) -> Void) {
        sink { [weak object] newValue in
            guard let object else {return}
            receiveValue(newValue, object)
        }.store(in: &object.cancellables)
    }
    func reload(_ view: UIDataView) -> AnyCancellable {
        sink { [weak view] _ in
            view?.reloadView()
        }
    }
}

public extension Publisher where Self.Output == Bool, Self.Failure == Never {
    func loadSkeleton(tableView: UITableView) -> AnyCancellable {
        sink { [weak tableView] state in
            guard let tableView else {return}
            _ = state ? tableView.showAnimatedGradientSkeleton(): tableView.hideSkeleton()
        }
    }
    func loadSkeleton(view: UIView) -> AnyCancellable {
        sink { [weak view] state in
            guard let view else {return}
            _ = state ? view.showAnimatedGradientSkeleton(): view.hideSkeleton()
        }
    }
}

public protocol UIDataView: AnyObject {
    func reloadView()
}

extension UITableView: UIDataView {
    public func reloadView() {
        reloadData()
    }
}

extension UICollectionView: UIDataView {
    public func reloadView() {
        reloadData()
    }
}

public protocol CancellableProvider: AnyObject {
    var cancellables: Set<AnyCancellable> {get set}
}
