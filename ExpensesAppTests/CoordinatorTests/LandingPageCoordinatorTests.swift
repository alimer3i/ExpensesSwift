//
//  LandingPageCoordinatorTests.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
@testable import ExpensesApp


final class LandingPageCoordinatorTests: XCTestCase, setUpProtocol {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    
    func test_whenClickGetStartedFromLandingPage_ShouldGoToSignUpPage() throws {
        // Given
        let appCoordinator = setup(provider: FakeUIDeviceInfoProvider())
        appCoordinator.start()
        
        guard let landingCoor = appCoordinator.children.first as? LandingCoordinator  else {
            return
        }
        
        landingCoor.goToSignUp()
        // Then
       assertSignUpPage(appCoordinator: appCoordinator)
    }
    
    func test_whenClickSignInFromLandingPage_ShouldGoToSigInPage() throws {
        let appCoordinator = setup(provider: FakeUIDeviceInfoProvider())
        appCoordinator.start()
        
        
        guard let landingCoor = appCoordinator.children.first as? LandingCoordinator  else {
            return
        }
        
        landingCoor.goToSignIn()
        assertSignInPage(appCoordinator: appCoordinator)
    }
    
    private func assertSignUpPage(appCoordinator: Coordinator) {
        XCTAssertTrue(appCoordinator.children.count == 1,
                      "app coordinator children should contain Sign Up view only ")
        
        XCTAssertTrue(appCoordinator.children.first is RegisterCoordinator)
    }
    
    private func assertSignInPage(appCoordinator: Coordinator) {
        XCTAssertTrue(appCoordinator.children.count == 1,
                      "app coordinator children should contain SingIn view only ")
        
        XCTAssertTrue(appCoordinator.children.first is SignInCoordinator)
    }

}
