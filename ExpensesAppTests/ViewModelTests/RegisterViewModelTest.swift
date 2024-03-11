//
//  RegisterViewModelTest.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import XCTest
import Combine
@testable import ExpensesApp

class RegisterViewModelTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_ShouldGoToVerify_WhenRegisterUserSucceeded() {
        // Given
        let usecase = RegisterUseCaseStub(type: .success)
        let args = RegisterUseCaseStub.dummyArgs
        
        let sut = RegisterVM(useCase: usecase)
        
        var didGoToVerify = false
        
        let sub = sut.signUpRouteSubject.sink { route in
            switch route {
            case .verify:
                didGoToVerify = true
            default: break
            }
        }
        
        //When
        sut.registerUseCase.execute(input: args)
        
        //Expected
        XCTAssertTrue(didGoToVerify, #function)
        sub.cancel()
    }
    
    func test_ShouldNotGoToVerify_WhenRegisterUserFailed() {
        // Given
        let usecase = RegisterUseCaseStub(type: .failure)
        let args = RegisterUseCaseStub.dummyArgs
        
        let sut = RegisterVM(useCase: usecase)
        
        var didGoToVerify = false
        
        let sub = sut.signUpRouteSubject.sink { route in
            switch route {
            case .verify:
                didGoToVerify = true
            default: break
            }
        }
        //When
        sut.registerUseCase.execute(input: args)
        
        //Expected
        XCTAssertFalse(didGoToVerify, #function)
        sub.cancel()
    }
}
