//
//  FAQViewController.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit
import Combine

class HomeViewController: BaseViewController,
                         HomeViewControllerProtocol {

    //MARK: - Outlets
    @IBOutlet weak var tableView: CGTableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!

    //MARK: - Properties
    
    var viewModel: HomeVMProtocol?
    var subscriptions = [AnyCancellable]()
    
    //MARK: - Init
    convenience init(VM: HomeVMProtocol?) {
        self.init(viewModel: VM)
    }
    
    init(viewModel: HomeVMProtocol?) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel as! BaseVM)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        filterButton.contentHorizontalAlignment = .fill
        filterButton.contentVerticalAlignment = .fill
        filterButton.imageView?.contentMode = .scaleAspectFit
        titleLabel.text = "Dashboard"
        viewModel?.fetchData()
    }
    
    override func bindPublishers() {
        super.bindPublishers()
        viewModel?.reloadTableViewAt
            .sink { [weak self] indexPath in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            .store(in: &subscriptions)
        
        viewModel?.setUpHeader
            .sink { [weak self] (isDisplayed, total, income, expense) in
                let header = Bundle.main.loadNibNamed("ReportView", owner: self, options: nil)?.last as! ReportView
                header.frame.size.height = 250.0
                header.setUp(total: total, expense: expense, income: income)
                self?.tableView.tableHeaderView = isDisplayed ? header : UIView()
            }
            .store(in: &subscriptions)
        
    }
    
    //MARK: - Functions
    func setupTableView() {
        guard let viewModel = viewModel as? HomeVM else {
            return
        }
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = 40
        tableView
            .bind(viewModel.$cells)
            .onRefresh { [weak self] in
                self?.viewModel?.fetchData()
            }
            .showEmptyDataSet(title: "No Results Found")
        

    }
    
    @IBAction func filterClicked(_ sender: Any) {
        viewModel?.HomePageRouteSubject.send(.filter)
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        viewModel?.HomePageRouteSubject.send(.addExpense)
    }
}
