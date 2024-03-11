//
//  CoordinatorController.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

struct CoordinatorController {
    var childControllers = [UIViewController]()
    var navigationController: UINavigationController?
    var viewController: UIViewController?
    var type: CoordinatorControllerType
    var root: Bool
    var lastController: UIViewController? {
        if type == .presentation {
            return viewController
        }
        return childControllers.last
    }
    static func navigation(_ controller: UINavigationController, destination: UIViewController, root: Bool = false) -> Self {
        return CoordinatorController(childControllers: [destination], navigationController: controller, type: .navigation, root: root)
    }
    static func presentation(_ destination: UIViewController, root: Bool = false) -> Self {
        return CoordinatorController(viewController: destination, type: .presentation, root: root)
    }
    static func panModal(_ destination: UIViewController) -> Self {
        return CoordinatorController(viewController: destination, type: .panModal, root: false)
    }
    var coordinatorController: Self {
        let newChildControllers = [childControllers.last].compactMap({$0})
        return CoordinatorController(childControllers: newChildControllers, navigationController: navigationController, viewController: viewController, type: type, root: false)
    }
}

enum CoordinatorControllerType {
    case navigation, presentation, panModal
}
