//
//  OtpPageFactory.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit

class FilterPageFactory {
    static func assemble(homeVM: HomeVMProtocol, selectedType: String, selectedTag: String) -> UIViewController? {
        
        let viewModel = FilterVM(homeVM: homeVM, selectedType: selectedType, selectedTag: selectedTag)
        let filterView = FilterViewController(VM: viewModel)
      
        return filterView
    }
}
