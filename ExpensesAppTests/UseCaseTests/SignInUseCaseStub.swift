//
//  SignInUseCaseStub.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation
import XCTest
import Combine
@testable import ExpensesApp

class SignInUseCaseStub: SingInUseCase {
    
    var responseType: DesiredResponseType
    var returnedError: Error?
    
    init(type: DesiredResponseType) {
        self.responseType = type
    }
    
    override func execute(input: SignInArgs) {
        switch responseType {
        case .success:
            returnedResult.send(.success(value: UserModel()))
        case .failure:
            let err = returnedError == nil ? TestError() : returnedError!
            returnedResult.send(.failure( err))
        }
    }
}

extension SignInUseCaseStub {
    static var dummyArgs: SignInArgs {
        SignInArgs(
            phoneCode: "",
            phoneNumber: "",
            password: "",
            captchaToken: ""
        )
    }
}

class SignInUseCaseTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_GetUserInfo_WhenSignInSucceeded() {
        let usecase = SignInUseCaseStub(type: .success)
        
        var resultUser: UserModel?
        
        let sub = usecase.returnedResult
            .sink { result in
                switch result {
                case .success(value: let user):
                    resultUser = user
                case .failure(_ ): break
                }
            }
        
        usecase.execute(input: SignInUseCaseStub.dummyArgs)
        
        XCTAssertNotNil(resultUser, #function)
        sub.cancel()
    }
    
    func test_ErrorReturned_WhenSignInFailed() {
        let usecase = SignInUseCaseStub(type: .failure)
        var expectedError: TestError?
        
        let sub = usecase.returnedResult
            .sink { result in
            switch result {
            case .success: break
            case let .failure(error):
                expectedError = error as? TestError
            }
        }
        
        usecase.execute(input: SignInUseCaseStub.dummyArgs)
        XCTAssertNotNil(expectedError, #function)
        sub.cancel()
    }
}
