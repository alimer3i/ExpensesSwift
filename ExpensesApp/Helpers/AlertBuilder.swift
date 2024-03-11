//
//  AlertBuilder.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public struct Alert {
    public var title: String
    public var body: String
    public var actions: [AlertAction]
    public init(title: String, body: String) {
        self.title = title
        self.body = body
        self.actions = []
    }
    public func with(@AlertActionBuilder actions: () -> AlertActionResults) -> Self {
        var new = self
        new.actions = actions().result
        return new
    }
    var alert: UIAlertController {
        let controller = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let newActions = actions.isEmpty ? [AlertAction(title: "OK", style: .cancel)]: actions
        newActions.map(\.alertAction).forEach { action in
            controller.addAction(action)
        }
        return controller
    }
}

public struct AlertAction {
    public var title: String
    public var style: UIAlertAction.Style
    public var action: (() -> Void)?
    var alertAction: UIAlertAction {
        return UIAlertAction(title: title, style: style) { _ in
            action?()
        }
    }
}

@resultBuilder
public struct AlertActionBuilder {
    public static func buildBlock(_ parts: any AlertActionable...) -> AlertActionResults {
        let results = parts.reduce(into: [AlertAction]()) { partialResult, item in
            partialResult.append(contentsOf: item.result)
        }
        return AlertActionResults(actions: results)
    }
    static func buildEither<Component: AlertActionable>(first component: Component) -> some AlertActionable {
        return AlertActionResults(actions: component.result)
    }
    static func buildEither<Component: AlertActionable>(second component: Component) -> some AlertActionable {
        return AlertActionResults(actions: component.result)
    }
}

public struct AlertActionResults: AlertActionable {
    public var actions: [AlertAction]
    public var result: [AlertAction] {
        return actions
    }
}

public protocol AlertActionable {
    var result: [AlertAction] {get}
}

extension AlertAction: AlertActionable {
    public var result: [AlertAction] {
        return [self]
    }
}
