//
//  FAQPageFactory.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit

class HomePageFactory {
    static func assemble() -> HomeViewControllerProtocol? {
        let viewModel = HomeVM(useCase: HomeUseCase())
        let view = HomeViewController(VM: viewModel)
        
        return view
    }
}
