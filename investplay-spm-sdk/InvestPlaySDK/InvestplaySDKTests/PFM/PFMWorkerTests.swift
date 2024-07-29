//
//  PFMWorkerTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

@testable import InvestplaySDK
@testable import NetworkSdk
import XCTest

class PFMWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: PFMWorker!
    var linksRestApiSpy: LinksRestApiSpy!
    var spendingsRestApiSpy: SpendingsRestApiSpy!
    var servicesRestApiSpy: ServicesRestApiSpy!
    var transactionsRestApiSpy: TransactionsRestApiSpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPFMWorker()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        linksRestApiSpy = nil
        spendingsRestApiSpy = nil
        servicesRestApiSpy = nil
        transactionsRestApiSpy = nil
    }

    // MARK: Test setup

    func setupPFMWorker() {
        linksRestApiSpy = LinksRestApiSpy()
        spendingsRestApiSpy = SpendingsRestApiSpy()
        servicesRestApiSpy = ServicesRestApiSpy()
        transactionsRestApiSpy = TransactionsRestApiSpy()

        sut = PFMWorker(
            linksAPI: linksRestApiSpy,
            servicesAPI: servicesRestApiSpy,
            transactionsAPI: transactionsRestApiSpy,
            spendingsAPI: spendingsRestApiSpy
        )
    }

    // MARK: Tests

    func testGetLinksWithSuccess() {
        // Given
        let expectation = expectation(description: "Wait for getLinks() to return")

        linksRestApiSpy.getLinksCompletionHandler = { loadServices, completion in
            XCTAssertTrue(loadServices)
            completion(MockData.linkList, nil)
            expectation.fulfill()
        }

        // When
        sut.getLinks { response in
            switch response {
            case .success(let links):
                XCTAssertEqual(links, MockData.linkList)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(linksRestApiSpy.wasGetLinksCalled)
    }

    func testGetLinksWithError() {
        // Given
        let expectation = expectation(description: "Wait for getLinks() to return")

        linksRestApiSpy.getLinksCompletionHandler = { loadServices, completion in
            XCTAssertTrue(loadServices)
            completion(nil, Error(code: .unknownError, message: ""))
            expectation.fulfill()
        }

        // When
        sut.getLinks { response in
            switch response {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .notFound)
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(linksRestApiSpy.wasGetLinksCalled)
    }

    func testGetServicesWithSuccess() {
        // Given
        let expectation = expectation(description: "Wait for getServices() to return")

        servicesRestApiSpy.getServicesCompletionHandler = { linkId, completion in
            XCTAssertEqual(linkId, "testLink")
            completion(MockData.serviceList, nil)
            expectation.fulfill()
        }

        // When
        sut.getServices(for: "testLink") { response in
            switch response {
            case .success(let services):
                XCTAssertEqual(services, MockData.serviceList)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(servicesRestApiSpy.wasGetServicesCalled)
    }

    func testGetServicesWithError() {
        // Given
        let expectation = expectation(description: "Wait for getServices() to return")

        servicesRestApiSpy.getServicesCompletionHandler = { linkId, completion in
            XCTAssertEqual(linkId, "testLink")
            completion(nil, Error(code: .unknownError, message: ""))
            expectation.fulfill()
        }

        // When
        sut.getServices(for: "testLink") { response in
            switch response {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .notFound)
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(servicesRestApiSpy.wasGetServicesCalled)
    }

    func testGetSpendingsWithSuccess() {
        // Given
        let expectation = expectation(description: "Wait for getSpending() to return")

        spendingsRestApiSpy.getSpendingsCompletionHandler = { _, _, completion in
            completion(MockData.spending, nil)
            expectation.fulfill()
        }

        // When
        sut.getSpendings { response in
            switch response {
            case .success(let spending):
                XCTAssertEqual(spending.insights.count, MockData.spending.insights.count)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(spendingsRestApiSpy.wasGetSpendingsCalled)
    }

    func testGetSpendingsWithError() {
        // Given
        let expectation = expectation(description: "Wait for getSpending() to return")

        spendingsRestApiSpy.getSpendingsCompletionHandler = { _, _, completion in
            completion(nil, Error(code: .unknownError, message: ""))
            expectation.fulfill()
        }

        // When
        sut.getSpendings { response in
            switch response {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .notFound)
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(spendingsRestApiSpy.wasGetSpendingsCalled)
    }

    func testGetTransactionsWithSuccess() {
        // Given
        let expectation = expectation(description: "Wait for getTransactions() to return")

        transactionsRestApiSpy.getTransactionsWithSummaryCompletionHandler = { _, _, completion in
            completion(MockData.transactionWithSummary, nil)
            expectation.fulfill()
        }

        // When
        sut.getTransactions { response in
            switch response {
            case .success(let transactions):
                XCTAssertEqual(transactions, MockData.transactionWithSummary)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(transactionsRestApiSpy.wasGetTransactionsWithSummaryCalled)
    }

    func testGetTransactionsWithError() {
        // Given
        let expectation = expectation(description: "Wait for getTransactions() to return")

        transactionsRestApiSpy.getTransactionsWithSummaryCompletionHandler = { _, _, completion in
            completion(nil, Error(code: .unknownError, message: ""))
            expectation.fulfill()
        }

        // When
        sut.getTransactions { response in
            switch response {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .notFound)
            }
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(transactionsRestApiSpy.wasGetTransactionsWithSummaryCalled)
    }
}
