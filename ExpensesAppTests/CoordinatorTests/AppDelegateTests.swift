//
//  AppDelegateTests.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
@testable import ExpensesApp

class AppDelegateTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
}


// MARK: - Shared SetUp
protocol setUpProtocol {
    func setup(provider: UIDeviceInfoProviderProtocol) -> Coordinator
}

extension setUpProtocol {
     func setup(provider: UIDeviceInfoProviderProtocol) -> Coordinator {
        // given
        let appCoordinator = AppCoordinator(deviceProvider: provider)
        
        // when
        let app = AppDelegate.shared
        app.appCoordinator = appCoordinator
        return appCoordinator
    }
}

