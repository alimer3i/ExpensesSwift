//
//  SignInViewModelTest.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import XCTest
import Combine
@testable import ExpensesApp

class SignInViewModelTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_GoToHome_WhenSignInSucceeded() {
        // Given
        let usecase = SignInUseCaseStub(type: .success)
        let args = SignInUseCaseStub.dummyArgs
        
        let sut = SignInVM(useCase: usecase)
        
        var didGoToHome = false
        
        let sub = sut.navigateToHome
            .sink { value in
                didGoToHome = value
            }
        
        //When
        sut.signInUseCase.execute(input: args)
        
        //Expected
        XCTAssertTrue(didGoToHome, #function)
        sub.cancel()
    }
    
    func test_ShouldClearCaptchaToken_WhenSignInFailed() {
        // Given
        let usecase = SignInUseCaseStub(type: .failure)
        let args = SignInUseCaseStub.dummyArgs
        
        let sut = SignInVM(useCase: usecase)
        sut.captchaToken = "Some Random Token"
        
        //When
        sut.signInUseCase.execute(input: args)
        
        //Expected
        XCTAssertTrue(sut.captchaToken.isEmpty, #function)
    }
    
    func test_GoToVerify_WhenSignInReturnErrorStatusCode_40001() {
        // Given
        let usecase = SignInUseCaseStub(type: .failure)
        
        let err = ErrorResponseModel()
        err.responseCode = 40001
        
        usecase.returnedError = err
        let args = SignInUseCaseStub.dummyArgs
        
        let sut = SignInVM(useCase: usecase)
        sut.phoneCode = "020"
        sut.number = "100"
        
        var didGoToVerify = false
        
        let sub = sut.signInRouteSubject
            .sink { route in
                switch route {
                case .verify:
                    didGoToVerify = true
                default: break
                }
            }
        
        //When
        sut.signInUseCase.execute(input: args)
        
        //Expected
        XCTAssertTrue(didGoToVerify, #function)
        sub.cancel()
    }
}
