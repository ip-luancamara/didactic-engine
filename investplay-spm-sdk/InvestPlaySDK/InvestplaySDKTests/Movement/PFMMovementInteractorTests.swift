//
//  PFMMovementInteractorTests.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import XCTest
@testable import InvestplaySDK

class PFMMovementInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    var sut: PFMMovementInteractor!
    var presenter: PFMMovementPresenterMock!
    var notificationCenter: NotificationCenterSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setup()
    }
    
    // MARK: Test setup
    
    func setup() {
        presenter = PFMMovementPresenterMock()
        notificationCenter = NotificationCenterSpy()
        sut = PFMMovementInteractor(presenter: presenter, notificationCenter: notificationCenter)
        
    }
    
    func testInitMustAddObserver() {
        // Given
        let expectation = expectation(description: "Expected to call addObserver")
        
        notificationCenter.addObserverCompletionHandler = { observer, selector, name, object in
            XCTAssertTrue(observer is PFMMovementInteractor)
            XCTAssertEqual(name, .didUpdateTransaction)
            XCTAssertNil(object)
            expectation.fulfill()
        }
        
        // When
        sut = PFMMovementInteractor(presenter: presenter, notificationCenter: notificationCenter)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(notificationCenter.wasAddObserverCalled)
    }
    
    func testShowMovementsMustCallPresenter() {
        // Given
        let expectation = expectation(description: "Expected to call presentMovements")
        let filter = PFMDateFilter(month: 1, year: 2024)
        sut.dateFilter = filter
        
        presenter.presentMovementsCompletionHandler = { response in
            XCTAssertEqual(response.filterDate, filter)
            XCTAssertTrue(response.expenses.isEmpty)
            expectation.fulfill()
        }
        
        // When
        sut.showMovements(request: PFMMovement.ShowMovements.Request())
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.presentMovementsCalled)
    }
    
    func testDidTapDateChipMustCallPresentModal() {
        // Given
        let expectation = expectation(description: "Expected to call presentModal")
        
        presenter.presentModalCompletionHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.didTapDateChip()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.presentModalCalled)
    }
    
    func testDidTapMovementTypeMustCallPresentModal() {
        // Given
        let expectation = expectation(description: "Expected to call presentModal")
        
        presenter.presentModalCompletionHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.didTapMovementTypeChip()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.presentModalCalled)
    }
    
    func didSelectTabAllTransactionsMustCallPresenter() {
        // Given
        let expectation = expectation(description: "Expected to call presentAllTransactions")
        let filter = PFMDateFilter(month: 1, year: 2024)
        sut.dateFilter = filter
        
        presenter.presentAllTransactionsCompletionHandler = { response in
            XCTAssertEqual(response.filterDate, filter)
            XCTAssertTrue(response.expenses.isEmpty)
            expectation.fulfill()
        }
        
        // When
        sut.didSelect(tab: .allTransactions)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.presentAllTransactionsCalled)
    }
    
    func didSelectTabMyExpensesMustCallPresenter() {
        // Given
        let expectation = expectation(description: "Expected to call presentMovements")
        let filter = PFMDateFilter(month: 1, year: 2024)
        sut.dateFilter = filter
        
        presenter.presentMovementsCompletionHandler = { response in
            XCTAssertEqual(response.filterDate, filter)
            XCTAssertTrue(response.expenses.isEmpty)
            expectation.fulfill()
        }
        
        // When
        sut.didSelect(tab: .myExpenses)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.presentMovementsCalled)
    }
    
    func testDidSelectDateMustSetDateFilter() {
        // Given
        let year = 2024
        let month = 1
        
        // When
        sut.didSelect(month: month, year: year)
        
        // Then
        XCTAssertEqual(sut.dateFilter?.year, year)
        XCTAssertEqual(sut.dateFilter?.month, month)
    }
    
    func testDidTapCleanFilterMustSetMovementTypeFilter() {
        // Given
        sut.movementTypeFilter = .credit
        
        // When
        sut.didTapCleanFilter()
        
        // Then
        XCTAssertNil(sut.movementTypeFilter)
    }
}
