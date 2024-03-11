//
//  DeviceInfoProviderTests.swift
//  ExpensesAppTests
//
//  Created by Ali Merhie on 3/10/24.
//

import XCTest
@testable import ExpensesApp

struct FakeUIDeviceInfoProvider: UIDeviceInfoProviderProtocol  {
    var didJailBroken: Bool = false
    
    init(jailBorken: Bool = false) {
        self.didJailBroken = jailBorken
    }
    
    func deviceIsJailBroken() -> Bool {
        didJailBroken
    }
}

final class DeviceInfoProviderTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}


    func test_isJailBroken_ShouldReturnTrue() {
        // Given
        let deviceProvider = FakeUIDeviceInfoProvider(jailBorken: true)
        // Then
        XCTAssertTrue(deviceProvider.deviceIsJailBroken())
    }
    
    func test_isJailBroken_ShouldReturnFalse() {
        // Given
        let deviceProvider = FakeUIDeviceInfoProvider(jailBorken: false)
        // Then
        XCTAssertFalse(deviceProvider.deviceIsJailBroken())
    }
}
