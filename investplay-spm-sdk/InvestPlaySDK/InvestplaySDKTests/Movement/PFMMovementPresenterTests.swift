//
//  PFMMovementPresenterTests.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

@testable import InvestplaySDK
import XCTest

class PFMMovementPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    var sut: PFMMovementPresenter!
    var viewController: PFMMovementDisplayLogicMock!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        setup()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setup() {
        viewController = PFMMovementDisplayLogicMock()
        sut = PFMMovementPresenter(viewController: viewController)
    }
    
    func testPresentMovementsMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayMovements")
        
        viewController.displayMovementsCompletionHandler = { viewModel in
            XCTAssertEqual(viewModel.filterDate, "Janeiro de 2024")
            XCTAssertTrue(viewModel.expenses.isEmpty)
            expectation.fulfill()
        }
        
        // When
        sut.presentMovements(
            response: PFMMovement.ShowMovements.Response(
                filterDate: PFMDateFilter(month: 1, year: 2024),
                totalExpenses: 500,
                updatedAt: Date(),
                expenses: [:]
            )
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayMovementsCalled)
    }
    
    func testPresentModalMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayModal")
        
        let vc = UIViewController()
        
        viewController.displayModalCompletionHandler = { viewModel in
            XCTAssertEqual(viewModel.viewController, vc)
            expectation.fulfill()
        }
        
        // When
        sut.presentModal(
            response: PFMMovement.ShowModal.Response(
                viewController: vc
            )
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayModalCalled)
    }
    
    func testPresentAllTransactionsMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayAllTransactions")
        
        viewController.displayAllTransactionsCompletionHandler = { viewModel in
            XCTAssertEqual(viewModel.filterDate, "Janeiro de 2024")
            XCTAssertTrue(viewModel.expenses.isEmpty)
            XCTAssertEqual(viewModel.movementTypeFilter, .entries)
            expectation.fulfill()
        }
        
        // When
        sut.presentAllTransactions(
            response: PFMMovement.ShowAllTransactions.Response(
                filterDate: PFMDateFilter(month: 1, year: 2024),
                totalExits: 500,
                totalEntries: 500,
                updatedAt: Date(),
                movementTypeFilter: .credit,
                expenses: [:]
            )
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayAllTransactionsCalled)
    }
    
    func testPresentTransactionDetailsMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayTransactionDetails")
        
        viewController.displayTransactionDetailsCompletionHandler = { viewModel in
            expectation.fulfill()
        }
        
        // When
        sut.presentTransactionDetails(
            response: PFMMovement.TransactionDetails.Response()
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayTransactionDetailsCalled)
    }
}
