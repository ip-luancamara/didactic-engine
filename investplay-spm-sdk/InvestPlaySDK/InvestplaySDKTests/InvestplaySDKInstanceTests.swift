//
//  InvestplaySDKInstanceTests.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 01/04/24.
//

import XCTest
@testable import InvestplaySDK
@testable import NetworkSdk

final class InvestplaySDKTests: XCTestCase {

    var sut: InvestplaySDKInstance!

    override func setUpWithError() throws {
        sut = InvestplaySDKInstance()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDefaultMustGetAnInstance() {
        let instance = InvestplaySDKInstance.default

        XCTAssertNotNil(instance)
    }

    func testDelegateAndAuthProviderMustBeNil() {
        XCTAssertNil(sut.delegate)
    }

    func testDelegateMustBeSet() {
        // Given
        let expectation = expectation(description: "Delegate must be set")
        let delegate = MockDelegate(expectation: expectation)

        sut.delegate = delegate

        // When
        sut.delegate?.didTapRightButton(on: .financialManager)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(sut.delegate)
    }

    func testGetPFMMustReturnPFMViewControler() {
        // Given
        let viewController = sut.getPFM() as? PFMViewController

        // Then
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController?.interactor)
    }

//    func testGetPFMWithTokenMustSetTokenInPreferences() {
//        // Given
//        let viewController = sut.getPFM(token: "TokenMock") as? PFMViewController
//
//        // When
//        let token = Preferences.KEYS_APPLICATION.restApiSettings.get()
//
//        // Then
//        XCTAssertNotNil(viewController)
//        XCTAssertEqual(token, "TokenMock")
//    }
}

// MARK: Stubs for testing
private class MockDelegate: InvestplaySDKActionDelegate {

    let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func didTapRightButton(on screen: InvestplaySDK.InvestplaySDKScreen) {
        expectation.fulfill()
    }
    
    func goToMainScreen() {
        
    }
}

private class MockAuthProvider: InvestplaySDKAuthProvider {
    var token: String? {
        return "TokenMock"
    }

    var clientID: String? {
        return "ClientIdMock"
    }
}
