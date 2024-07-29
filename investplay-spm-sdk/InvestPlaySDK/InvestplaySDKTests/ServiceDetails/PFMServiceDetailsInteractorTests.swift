//
//  PFMServiceDetailsInteractorTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


@testable import InvestplaySDK
import XCTest

class PFMServiceDetailsInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: PFMServiceDetailsInteractor!
    var presenter: PFMServiceDetailsPresentationLogicSpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPFMServiceDetailsInteractor()
    }

    // MARK: Test setup

    func setupPFMServiceDetailsInteractor() {
        presenter = PFMServiceDetailsPresentationLogicSpy()
        sut = PFMServiceDetailsInteractor(presenter: presenter)
    }

    // MARK: Tests

    func testShowDetailsWithAccountSelectedMustCallPresenter() {
        // Given
        let expectation = expectation(description: "Present Show Details")
        let request = PFMServiceDetails.ShowServiceDetails.Request(dateFilter: .current)

        presenter.presentDetailsCompletion = { response in
            XCTAssertFalse(response.type.isCard)
            XCTAssertEqual(response.screenTitle, .accountDetails)
            expectation.fulfill()
        }

        sut.links = MockData.linkList
        sut.serviceFilter = MockData.serviceAccount

        // When
        sut.showDetails(request: request)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.wasPresentDetailsCalled, "showDetails(request:) should ask the presenter to format the result")
    }

    func testShowDetailsWithCardSelectedMustCallPresenter() {
        // Given
        let expectation = expectation(description: "Present Show Details")
        let request = PFMServiceDetails.ShowServiceDetails.Request(dateFilter: .current)

        presenter.presentDetailsCompletion = { response in
            XCTAssertTrue(response.type.isCard)
            XCTAssertEqual(response.screenTitle, .cardDetails)
            expectation.fulfill()
        }

        sut.links = MockData.linkList
        sut.serviceFilter = MockData.serviceCreditCard

        // When
        sut.showDetails(request: request)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.wasPresentDetailsCalled)
    }
}
