//
//  ForgetOtpViewController.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit
import Combine
import PanModal

class FilterViewController: BaseViewController,
                         FilterViewControllerProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    
    var viewModel: FilterViewModelProtocol?
    var subscriptions = [AnyCancellable]()
    
 
    //MARK: - Init
    convenience init(VM: FilterViewModelProtocol?) {
        self.init(viewModel: VM)
    }
    
    init(viewModel: FilterViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel as! BaseVM)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchData()
        titleLabel.text = "Filter"
        applyButton.setTitle("Apply", for: .normal)

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
                    strongSelf.viewModel?.selectedType = action.title
                  }
                
                for text in data {
                    menuChildren.append(UIAction(title: text, handler: actionClosure))
                }
           
             
                if #available(iOS 15.0, *) {
                    strongSelf.typeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
                    strongSelf.typeButton.showsMenuAsPrimaryAction = true
                    strongSelf.typeButton.changesSelectionAsPrimaryAction = true
                    
                    if let selectedItem = strongSelf.typeButton.menu?.children.first(where: { $0.title == strongSelf.viewModel?.selectedType}) as? UIAction {
                        selectedItem.state = .on
                    }
                }
            }
            .store(in: &subscriptions)
        
        viewModel.setupTags
            .sink { [weak self] data in
                guard let strongSelf = self else{return}
                var menuChildren: [UIMenuElement] = []
                
                let actionClosure = { (action: UIAction) in
                      print(action.title)
                    strongSelf.viewModel?.selectedTag = action.title
                  }
                
                for text in data {
                    menuChildren.append(UIAction(title: text, handler: actionClosure))
                }
           
                if #available(iOS 15.0, *) {
                    strongSelf.tagButton.menu = UIMenu(options: .displayInline, children: menuChildren)
                    strongSelf.tagButton.showsMenuAsPrimaryAction = true
                    strongSelf.tagButton.changesSelectionAsPrimaryAction = true
                    
                    if let selectedItem = strongSelf.tagButton.menu?.children.first(where: { $0.title == strongSelf.viewModel?.selectedTag}) as? UIAction {
                        selectedItem.state = .on
                    }

                }
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func tappedBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func applyClicked(_ sender: Any) {
        viewModel?.applyClicked()
    }
}

//MARK: - PanModalPresentable
extension FilterViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
    var showDragIndicator: Bool {
        return false
    }
    var cornerRadius: CGFloat {
        return 30
    }
}

