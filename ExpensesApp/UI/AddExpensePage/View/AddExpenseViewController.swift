//
//  ForgetOtpViewController.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/7/21.
//

import UIKit
import Combine

class AddExpenseViewController: BaseViewController,
                         AddExpenseViewControllerProtocol {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var occuredDatePicker: UIDatePicker!
    
    var viewModel: AddExpenseViewModelProtocol?
    var subscriptions = [AnyCancellable]()
    
 
    //MARK: - Init
    convenience init(VM: AddExpenseViewModelProtocol?) {
        self.init(viewModel: VM)
    }
    
    init(viewModel: AddExpenseViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel as! BaseVM)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchData()
        titleLabel.text = "Add Transaction"
        addButton.setTitle("Add", for: .normal)
        amountTextField.placeholder = "Amount"
        noteTextField.placeholder = "Note"
        titleTextField.placeholder = "Title"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bindPublishers() {
        super.bindPublishers()
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.setupTypes
            .sink { [weak self] data in
                guard let strongSelf = self else{return}
                var menuChildren: [UIMenuElement] = []
                
                let actionClosure = { (action: UIAction) in
                      print(action.title)
                    strongSelf.viewModel?.selectedType = TransactionTypeEnum(rawValue: action.title) ?? .expense
                  }
                
                for text in data {
                    menuChildren.append(UIAction(title: text, handler: actionClosure))
                }
           
                if #available(iOS 15.0, *) {
                    strongSelf.typeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
                    strongSelf.typeButton.showsMenuAsPrimaryAction = true
                    strongSelf.typeButton.changesSelectionAsPrimaryAction = true
                }
            }
            .store(in: &subscriptions)
        
        viewModel.setupTags
            .sink { [weak self] data in
                guard let strongSelf = self else{return}
                var menuChildren: [UIMenuElement] = []
                
                let actionClosure = { (action: UIAction) in
                      print(action.title)
                    strongSelf.viewModel?.selectedTag = TransactionTagEnum(rawValue: action.title) ?? .transport
                  }
                
                for text in data {
                    menuChildren.append(UIAction(title: text, handler: actionClosure))
                }
           
                if #available(iOS 15.0, *) {
                    strongSelf.tagButton.menu = UIMenu(options: .displayInline, children: menuChildren)
                    strongSelf.tagButton.showsMenuAsPrimaryAction = true
                    strongSelf.tagButton.changesSelectionAsPrimaryAction = true
                }
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func tappedBackBtn(_ sender: Any) {
        viewModel?.addExpenseRouteSubject.send(.back)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        viewModel?.addClicked(title: titleTextField.text ?? "", amountStr: amountTextField.text ?? "", note: noteTextField.text ?? "", occuredDate: occuredDatePicker.date)
    }
}

