//
//  FAQVM.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/15/21.
//

import Foundation
import Combine

class HomeVM: BaseVM,
              HomeVMProtocol {
    
    
    //MARK: - Publishers
    @Published var cells = Cells()
    var reloadTableViewAt = PassthroughSubject<IndexPath, Never>()
    var setUpHeader = PassthroughSubject<(isDisplayed: Bool, total: String, income: String, expense: String), Never>()
    var cellsSubject = CurrentValueSubject<Cells, Never>([])
    var HomePageRouteSubject: PassthroughSubject<HomePageRoute, Never> = PassthroughSubject<HomePageRoute, Never>()
    var filterAppliedSubject = PassthroughSubject<(type: String, tag: String), Never>()
    var subscriptions = [AnyCancellable]()
    var appliedFilter = (type: "all", tag: "all"){
        didSet{
            fetchData()
        }
    }

    var homeUseCase: HomeUseCase!

    //MARK: - Properties
    private var expenses = [ExpenseModel]() {
        didSet {
            expensesDisplay = expenses
            setUpHeader.send(getTotalBalance())
        }
    }
    
    init(useCase: HomeUseCase) {
        super.init()
        self.homeUseCase = useCase
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .expensesUpdated, object: nil)
        bindUsecaseResult()
        
        self.filterAppliedSubject
            .sink { [weak self] result in
                self?.appliedFilter = result
            }
            .store(in: &subscriptions)
    }
    private func getTotalBalance() -> (isDisplayed: Bool, total: String, income: String, expense: String) {
        var total = Double(0)
        var income = Double(0)
        var expense = Double(0)

        for i in expenses {
            if i.type == TransactionTypeEnum.income.rawValue {
                total += i.amount
                income += i.amount
            }
            else if i.type == TransactionTypeEnum.expense.rawValue {
                total -= i.amount
                expense += i.amount
            }
        }
        return (expenses.count != 0  ,"$\(String(format: "%.2f", total))", "+$\(String(format: "%.2f", income))", "-$\(String(format: "%.2f", expense))")
    }
    
    private var expensesDisplay = [ExpenseModel]() {
        didSet {
            cells = ExpenseTableCellViewModel.iterate(using: expensesDisplay, for: \.item)
        }
    }
    
    @objc func fetchData() {

        Task {
            await homeUseCase.execute(input: (type: appliedFilter.type, tag: appliedFilter.tag))
        }
    }
    
    
    private func bindUsecaseResult() {
        homeUseCase
            .returnedResult
            .receive(on: DispatchQueue.main)
            .sink(self) { result, strongSelf in
                strongSelf.hideLoader()
                switch result {
                case .success(let expenses):
                        strongSelf.expenses = expenses
                case .failure:
                    break
                }
            }
    }
}
