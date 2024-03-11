//
//  CoordinatorProtocol.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit
import Combine
import PanModal

typealias PanModalController = UIViewController & PanModalPresentable

open class Coordinator {
    //MARK: - Properties
    weak var parentCoordinator: Coordinator?
    private var children = [Coordinator]()
    public var cancellables = Set<AnyCancellable>()
    private var controllers = [CoordinatorController]()
    static let root = AppDelegate.shared.appCoordinator
    //MARK: - Functions
    open func start() {
        print("\(self) Started")
    }
    func present(_ destination: UIViewController, from source: UIViewController? = nil, style: UIModalPresentationStyle = .overFullScreen, transition: UIModalTransitionStyle = .coverVertical, withNavigation: Bool = false, animated: Bool = true, sourceView: UIView? = nil, sourceRect: CGRect = .zero, completion: (() -> Void)? = nil) {
        bindDissmisal(destination as? BaseViewController)
        let destinationViewController: UIViewController
        let controller: CoordinatorController
        if withNavigation {
            let navigationController = NavigationControllerFactory.create(view: destination)
            destinationViewController = navigationController
            controller = .navigation(navigationController, destination: destination)
        }else {
            destinationViewController = destination
            controller = .presentation(destination)
        }
        destinationViewController.modalPresentationStyle = style
        destinationViewController.modalTransitionStyle = transition
        destinationViewController.popoverPresentationController?.sourceView = sourceView
        destinationViewController.popoverPresentationController?.sourceRect = sourceRect
        (source ?? controllers.last?.lastController)?.present(destinationViewController, animated: animated) { [weak self] in
            self?.controllers.append(controller)
            completion?()
        }
    }
    func presentPanModal(_ destination: PanModalController, from source: UIViewController? = nil, sourceView: UIView? = nil, sourceRect: CGRect = .zero) {
        bindDissmisal(destination as? BaseViewController)
        let presentingController = controllers.last?.type == .panModal ? UIApplication.getTopViewController(): controllers.last?.lastController
        (source ?? presentingController)?.presentPanModal(destination, sourceView: sourceView, sourceRect: sourceRect)
        controllers.append(.panModal(destination))
    }
    func push(_ destination: UIViewController, controller: UINavigationController? = nil, animated: Bool = true) {
        let lastIndex = controllers.endIndex - 1
        guard !controllers.isEmpty else {return}
        bindDissmisal(destination as? BaseViewController)
        (controller ?? controllers.last?.navigationController)?.pushViewController(destination, animated: animated)
        controllers[lastIndex].childControllers.append(destination)
    }
    func pop(animated: Bool = true, isPopped: Bool = false) {
        let lastIndex = controllers.endIndex - 1
        guard let lastController = controllers.last, !controllers.isEmpty, controllers[lastIndex].childControllers.count > 1 else {return}
        controllers[lastIndex].childControllers.removeLast()
        if !isPopped {
            lastController.navigationController?.popViewController(animated: animated)
        }
        if !(controllers.last?.root ?? false) && (controllers.last?.childControllers.count ?? 0) < 2 {
            removeFromParent()
        }
    }
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil, isDismissed: Bool = false) {
        guard let lastController = controllers.last, !lastController.root else {return}
        var dismissController: UIViewController?
        if !isDismissed {
            switch lastController.type {
                case .navigation:
                    dismissController = lastController.navigationController
                case .presentation, .panModal:
                    dismissController = lastController.lastController
            }
        }
        if isDismissed {
            controllers.removeLast()
            if !(controllers.last?.root ?? false) && (controllers.last?.childControllers.count ?? 0) < 2 {
                removeFromParent()
            }
        }else {
            dismissController?.dismiss(animated: animated) { [weak self] in
                guard let self else {return}
                self.controllers.removeLast()
                completion?()
                if !(self.controllers.last?.root ?? false) && (self.controllers.last?.childControllers.count ?? 0) < 2 {
                    self.removeFromParent()
                }
            }
        }
    }
    func bindDissmisal(_ controller: BaseViewController?) {
        controller?.$dismissCoordinatorController
            .receive(on: DispatchQueue.main)
            .sink(self) { style, strongSelf in
                switch style {
                    case .dismiss:
                        strongSelf.dismiss(isDismissed: true)
                    case .pop:
                        strongSelf.pop(isPopped: true)
                }
            }.store(in: &cancellables)
    }
    func setRoot(_ viewController: UIViewController, withNavigation: Bool = false) {
        let rootViewController: UIViewController
        if withNavigation {
            let navigationController = NavigationControllerFactory.create(view: viewController)
            rootViewController = navigationController
            controllers = [.navigation(navigationController, destination: viewController, root: true)]
        }else {
            rootViewController = viewController
            controllers = [.presentation(viewController, root: true)]
        }
        NetworkReachability.shared.recheckConnection()
        WindowHelper.shared.window.rootViewController = rootViewController
    }
    func add(child coordinator: Coordinator, to newParent: Coordinator? = nil) {
        guard let newParent else {
            let lastController = controllers.last?.coordinatorController
            coordinator.controllers = lastController == nil ? []: [lastController!]
            coordinator.parentCoordinator = self
            children.append(coordinator)
            coordinator.start()
            return
        }
        removeFromParent()
        coordinator.parentCoordinator = newParent
        newParent.children.append(coordinator)
        coordinator.start()
    }
    func setController(_ viewController: UIViewController, navigationController: UINavigationController? = nil) {
        if let navigationController {
            controllers = [.navigation(navigationController, destination: viewController, root: true)]
        }else {
            controllers = [.presentation(viewController, root: true)]
        }
    }
    func setTab(coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        children.append(coordinator)
        coordinator.start()
    }
    private func removeFromParent() {
        parentCoordinator?.children.removeAll(where: {$0 === self})
        parentCoordinator = nil
        children.removeAll()
        controllers.removeAll()
    }
    //MARK: - Deinitializer
    deinit {
        print("Memory to be released soon \(self)")
    }
}

struct NavigationControllerFactory {
    static func create(view: UIViewController) -> RTLNavigationController {
        return RTLNavigationController(rootViewController: view)
    }
}
