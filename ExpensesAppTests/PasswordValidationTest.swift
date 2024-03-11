//
//  PasswordValidationTest.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
import Foundation
@testable import ExpensesApp

final class PasswordValidationTest: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}


    func test_ValidPassowrd() throws {
        let actualRes = "1!RandomPasw00rd".passwordValidated
        XCTAssertTrue(actualRes)
    }
    
    func test_NotValidPass_lessThan_8_char() throws {
        let actualRes = "1Rando".passwordValidated
        XCTAssertFalse(actualRes)
    }
    
    func test_NotValidPass_Not_contain_UpperLetter() throws {
        let actualRes = "1randompassword".passwordValidated
        XCTAssertFalse(actualRes)
    }
    
    func test_NotValidPass_Not_contain_Lowerletter() throws {
        let actualRes = "1RANDOMPASSWORD".passwordValidated
        XCTAssertFalse(actualRes)
    }

}
