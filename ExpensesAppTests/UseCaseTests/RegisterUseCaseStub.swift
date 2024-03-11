//
//  FakeRegisterUseCase.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import XCTest
import Combine
@testable import ExpensesApp

enum DesiredResponseType {
    case success
    case failure
}

struct TestError: Error {}

class RegisterUseCaseStub: RegisterUseCase {
    
    var responseType: DesiredResponseType
    
    init(type: DesiredResponseType) {
        self.responseType = type
    }
    
    override func execute(input: RegisterUserSArgs) {
        switch responseType {
        case .success:
            returnedResult.send(.success(value: 100))
        case .failure:
            returnedResult.send(.failure(TestError()))
        }
    }
}

extension RegisterUseCaseStub {
    static var dummyArgs: RegisterUserSArgs {
        RegisterUserSArgs(phoneCode: "", phoneNumber: "", password: "", fullName: "")
    }
}

class RegisterUseCaseTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_UserIdsMatched_WhenRegisterSucceeded() {
        let usecase = RegisterUseCaseStub(type: .success)
        let expectedUserId  = 100
        var resultId = 0
        
        let sub = usecase.returnedResult.sink { result in
            switch result {
            case .success(value: let userId):
                resultId = userId
            case .failure(_ ): break
            }
        }
        
        usecase.execute(input: RegisterUseCaseStub.dummyArgs)
        XCTAssertTrue(resultId == expectedUserId, #function)
        sub.cancel()
    }
    
    func test_UserIdsNotMatched_WhenRegisterSucceeded() {
        let usecase = RegisterUseCaseStub(type: .success)
        let dummyArgs = RegisterUseCaseStub.dummyArgs
        let expectedUserId  = 110
        var resultId = 0
        
        let sub = usecase.returnedResult.sink { result in
            switch result {
            case .success(value: let userId):
                resultId = userId
            case .failure(_ ): break
            }
        }
        
        usecase.execute(input: dummyArgs)
        XCTAssertFalse(resultId == expectedUserId, #function)
        sub.cancel()
    }
    
    func test_ErrorReturned_WhenRegisterFailed() {
        let usecase = RegisterUseCaseStub(type: .failure)
        let dummyArgs = RegisterUserSArgs(phoneCode: "", phoneNumber: "", password: "", fullName: "")
        var expectedError: TestError?
        
        let sub = usecase.returnedResult.sink { result in
            switch result {
            case .success: break
            case let .failure(error):
                expectedError = error as? TestError
            }
        }
        
        usecase.execute(input: dummyArgs)
        XCTAssertNotNil(expectedError, #function)
        sub.cancel()
    }
}
