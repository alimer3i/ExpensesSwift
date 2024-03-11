//
//  ForgetOtpVM.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import Combine

class FilterVM: BaseVM,
                    FilterViewModelProtocol {
    
    var setupTypes = PassthroughSubject<[String], Never>()
    var setupTags = PassthroughSubject<[String], Never>()
    var updateDesc = PassthroughSubject<String, Never>()
    var selectedType: String = "all"
    var selectedTag: String = "all"
    
    var filterRouteSubject = PassthroughSubject<FilterPageRoute, Never>()
    var homeVm: HomeVMProtocol!
    
    override init() {
        super.init()
        bindUsecaseResult()
    }
    
    init(homeVM: HomeVMProtocol, selectedType: String, selectedTag: String){
        super.init()
        bindUsecaseResult()
        self.homeVm = homeVM
        self.selectedTag = selectedTag
        self.selectedType = selectedType
    }
    
    func fetchData(){
        var types: [String] = ["all"]
        for key in TransactionTypeEnum.allCases {
            types.append(key.rawValue)
        }
        setupTypes.send(types)
        
        var tags: [String] = ["all"]
        for key in TransactionTagEnum.allCases {
            tags.append(key.rawValue)
        }
        setupTags.send(tags)
    }
    private func bindUsecaseResult() {
        
    }
    func applyClicked(){
        homeVm.filterAppliedSubject.send((type: selectedType, tag: selectedTag))
        self.dismiss()
    }
    
}
