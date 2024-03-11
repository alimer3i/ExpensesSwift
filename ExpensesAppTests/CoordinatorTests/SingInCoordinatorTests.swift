//
//  SingInCoordinatorTests.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
@testable import ExpensesApp


final class SingInCoordinatorTests: XCTestCase, setUpProtocol {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_whenClickCreateNewAccountAtSingInPage_ShouldGoToSignUpPage() throws {
        // Given
        let appCoordinator = setup(provider: FakeUIDeviceInfoProvider())
        appCoordinator.start()
        
        guard let landingCoor = appCoordinator.children.first as? LandingCoordinator  else {
            return
        }
        
        landingCoor.goToSignIn()
        
        guard let singInCoor = appCoordinator.children.first as? SignInCoordinator  else {
            return
        }
        
        singInCoor.goToSignUp()
        
        XCTAssertTrue(appCoordinator.children.count == 1,
                      "app coordinator children should contain SignUp page view only ")
        
        XCTAssertTrue(appCoordinator.children.first is RegisterCoordinator)
    }
    
}
