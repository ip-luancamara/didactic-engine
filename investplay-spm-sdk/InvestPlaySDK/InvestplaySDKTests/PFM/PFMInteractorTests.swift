//
//  PFMInteractorTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

@testable import InvestplaySDK
import XCTest

class PFMInteractorTests: XCTestCase {
    // MARK: Subject under test

    var worker: PFMWorkerSpy!
    var presenter: PFMPresentationLogicSpy!
    var sut: PFMInteractor!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPFMInteractor()
    }

    // MARK: Test setup

    func setupPFMInteractor() {
        worker = PFMWorkerSpy()
        presenter = PFMPresentationLogicSpy()
        sut = PFMInteractor(worker: worker, presenter: presenter)
    }

    // MARK: Tests

    func testGetData() {
        // Given
        let presentLinksExpectation = expectation(description: "Wait presentLinks() to be called")
        let workerGetLinksExpectation = expectation(description: "Wait getLinks() to be called")
        let workerGetTransactionsExpectation = expectation(description: "Wait getTransactions() to be called")
        let workerGetSpendingsExpectation = expectation(description: "Wait getSpendings() to be called")

        let response = PFM.LoadView.Response(
            services: [],
            cards: [],
            allCardsBalance: 0,
            allAccountsBalance: 0,
            insights: [],
            spendings: [],
            spendingChartColor: .white
        )

        presenter.presentLinksCompletionHandler = { _ in
            presentLinksExpectation.fulfill()
        }

        worker.getLinksCompletionHandler = { completion in
            completion(.success(MockData.linkList))
            workerGetLinksExpectation.fulfill()
        }

        worker.getTransactionsCompletionHandler = { completion in
            completion(.success(MockData.transactionWithSummary))
            workerGetTransactionsExpectation.fulfill()
        }

        worker.getSpendingsCompletionHandler = { completion in
            completion(.success(MockData.spending))
            workerGetSpendingsExpectation.fulfill()
        }

        // When
        sut.getData(request: .init())

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.wasPresentLinksCalled)
        XCTAssertTrue(worker.wasGetLinksCalled)
        XCTAssertTrue(worker.wasGetTransactionsCalled)
        XCTAssertTrue(worker.wasGetSpendingsCalled)
    }

}
