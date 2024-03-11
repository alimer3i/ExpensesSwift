//
//  UIViewControllerExtensions.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

extension UIViewController {
    func show(alert: Alert, @AlertActionBuilder actions: () -> AlertActionResults) {
        let alert = alert.with(actions: actions)
        present(alert.alert, animated: true)
    }
    func show(alert: Alert) {
        present(alert.alert, animated: true)
    }
}
