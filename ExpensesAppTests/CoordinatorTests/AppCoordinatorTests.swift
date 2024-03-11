//
//  AppCoordinatorTests.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
@testable import ExpensesApp

final class AppCoordinatorTests: XCTestCase, setUpProtocol {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func test_ifJailBroken_ShouldShowJailBrokenView() throws {
        // Given
        let appCoordinator = setup(provider: FakeUIDeviceInfoProvider(jailBorken: true))
        appCoordinator.start()
        // Then
        assertJailPage(appCoordinator: appCoordinator)
    }
    
    func test_ifNotJailBroken_ShouldShowLandingView() throws {
        // Given
        let appCoordinator = setup(provider: FakeUIDeviceInfoProvider())
        appCoordinator.start()
        // then
        assertLandingPage(appCoordinator: appCoordinator)
    }
    
    private func assertLandingPage(appCoordinator: Coordinator) {
        XCTAssertTrue(appCoordinator.children.count == 1,
                      "app coordinator children should contain landing page view only ")
        
        XCTAssertTrue(appCoordinator.children.first is LandingCoordinator)
    }
    
    private func assertJailPage(appCoordinator: Coordinator) {
        XCTAssertTrue(appCoordinator.children.count == 1,
                      "app coordinator children should contain jail broken page only ")
        
        XCTAssertTrue(appCoordinator.children.first is JailBrokenPageCoordinator)
    }

}
