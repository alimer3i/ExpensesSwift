//
//  RootAppCoordinator.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
 
//MARK: - Functions
    override func start() {
        super.start()
        goToHomePage()
    }

    func goToHomePage() {
        let homeCoordinator = HomeCoordinator()
        add(child: homeCoordinator, to: .root)
    }
}
