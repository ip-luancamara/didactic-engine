//
//  PFMServiceDetailsPresenterTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


@testable import InvestplaySDK
import XCTest

class PFMServiceDetailsPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: PFMServiceDetailsPresenter!
    var viewController: PFMServiceDetailsDisplayLogicSpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPFMServiceDetailsPresenter()
    }

    // MARK: Test setup

    func setupPFMServiceDetailsPresenter() {
        viewController = PFMServiceDetailsDisplayLogicSpy()
        sut = PFMServiceDetailsPresenter(viewController: viewController)
    }

    // MARK: Tests

    func testPresentDetailsMustCallViewControllerOnMainThread() {
        // Given
        let expectation = expectation(description: "Present details should call view controller on main thread")

        let response = PFMServiceDetails.ShowServiceDetails.Response(
            type: .account(Account(id: .empty, bankName: .empty, imageURL: .empty, accountNumber: .empty, balance: .empty)),
            screenTitle: .accountDetails,
            updatedAt: Date(),
            selectedMonth: 1,
            selectedYear: 2024,
            totalEntries: 1000,
            totalExits: 500,
            balance: 0,
            transactions: [:],
            movementFilter: nil
        )

        viewController.displayDetailsCompletion = { viewModel in
            XCTAssertEqual(viewModel.screenTitle, "Detalhes da conta")
            XCTAssertEqual(viewModel.month, 1)
            XCTAssertEqual(viewModel.year, 2024)
            XCTAssertEqual(viewModel.totalEntries, "R$\u{00A0}1.000,00")
            XCTAssertEqual(viewModel.totalExits, "R$\u{00A0}500,00")
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }

        // When
        sut.presentDetails(response: response)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.wasDisplayDetailsCalled)
    }

    func testPresentModalMustCallViewControllerOnMainThread() {
        // Given
        let expectation = expectation(description: "Present modal should call view controller on main thread")

        let dummyViewController = UIViewController()

        let response = PFMServiceDetails.ServiceModal.Response(
            viewController: dummyViewController
        )

        viewController.displayModalCompletion = { viewModel in
            XCTAssertEqual(viewModel.viewController, dummyViewController)
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }

        // When
        sut.presentSelectModal(response: response)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.wasDisplayModalCalled, "presentModal(response:) should ask the view controller to display the result")
    }

}
