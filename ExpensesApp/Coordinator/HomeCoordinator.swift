//
//  Home.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit
import Combine

class HomeCoordinator: Coordinator {
    //MARK: - Lifecycle
    private var homePageSubscription: AnyCancellable?
    private var addExpenseSubscription: AnyCancellable?
    private var filterSubscription: AnyCancellable?
    private var homeViewModel: HomeVMProtocol!

    override func start() {
        super.start()
        goToHomePage()
    }
    //MARK: - Functions
    private func goToHomePage() {
        guard let view = HomePageFactory.assemble(), let viewModel = view.viewModel else {return}
        homeViewModel = viewModel
        homePageSubscription = viewModel.HomePageRouteSubject
            .sink(self) { route, strongSelf in
                switch route {
                case .addExpense:
                    strongSelf.goToAddExpense()
                case .filter:
                   strongSelf.goToFilter(selectedType: viewModel.appliedFilter.type, selectedTag: viewModel.appliedFilter.tag)
                }
            }
        setRoot(view as! UIViewController, withNavigation: true)
    }
    func goToAddExpense() {
        guard let addExpenseView = AddExpensePageFactory.assemble() as? AddExpenseViewControllerProtocol, let viewModel = addExpenseView.viewModel else {return}
        addExpenseSubscription = viewModel.addExpenseRouteSubject
            .sink(self) { route, strongSelf in
                switch route {
                case .back:
                    strongSelf.pop()
                }
            }
        push(addExpenseView as! UIViewController)
    }
    func goToFilter(selectedType: String, selectedTag: String) {
        guard let filterView = FilterPageFactory.assemble(homeVM: homeViewModel, selectedType: selectedType, selectedTag: selectedTag) as? FilterViewControllerProtocol, let viewModel = filterView.viewModel else {return}
        filterSubscription = viewModel.filterRouteSubject
            .sink(self) { route, strongSelf in
                switch route {
                case .back:
                    strongSelf.dismiss(animated: true)
                }
            }
        presentPanModal(filterView as! PanModalController)
    }
}
