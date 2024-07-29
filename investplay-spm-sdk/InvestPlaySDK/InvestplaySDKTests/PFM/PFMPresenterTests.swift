//
//  PFMPresenterTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

@testable import InvestplaySDK
import XCTest

class PFMPresenterTests: XCTestCase {
    // MARK: Subject under test

    var viewController: PFMDisplayLogicSpy!
    var sut: PFMPresenter!

    // MARK: Test lifecycle

    @MainActor
    override func setUp() {
        super.setUp()
        viewController = PFMDisplayLogicSpy()
        sut = PFMPresenter(viewController: viewController)
    }

    // MARK: Tests

    func testPresentLinksMustCallViewController() {
        // Given
        let expect = expectation(description: "Wait presentLinks() to be called")

        let response = PFM.LoadView.Response(
            services: [],
            cards: [],
            allCardsBalance: 200,
            allAccountsBalance: 350,
            insights: [],
            spendings: [
                MonthSpending(
                    total: 500,
                    month: "Dezembro",
                    year: "2024",
                    shortMonth: "Dez",
                    shortYear: "24",
                    spendings: [SpendingCategory(
                        id: "1", 
                        title: "Compras",
                        value: "R$ 250",
                        icon: "",
                        percentage: 20,
                        color: .cyan
                    )]
                )
            ],
            spendingChartColor: .purple
        )

        viewController.displayLinksCompletionHandler = { viewModel in
            XCTAssertTrue(viewModel.accounts.isEmpty)
            XCTAssertTrue(viewModel.cards.isEmpty)
            XCTAssertEqual(viewModel.allCardsBalance, 200)
            XCTAssertEqual(viewModel.allAccountsBalance, 350)
            XCTAssertTrue(viewModel.insights.isEmpty)
            XCTAssertEqual(viewModel.spendings.first?.totalSpendings, "R$\u{00A0}500,00")
            XCTAssertEqual(viewModel.spendings.first?.headerSubtitle, "Dezembro 2024")
            XCTAssertEqual(viewModel.spendings.first?.spendings.first?.value, "20 %")
            expect.fulfill()
        }

        // When
        sut.presentLinks(response: response)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.wasDisplayLinksCalled)
    }

    func testPresentLoadingMustCallViewController() {
        // Given
        let expect = expectation(description: "Wait presentLoading() to be called")

        viewController.displayLoadingCompletionHandler = {
            expect.fulfill()
        }

        // When
        sut.presentLoading()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.wasDisplayLoadingCalled)
    }
}
