//
//  PFMMovementViewControllerTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


@testable import InvestplaySDK
import XCTest

class PFMMovementViewControllerTests: XCTestCase {

    // MARK: Subject under test
    var sut: PFMMovementViewController!

    var interactor: PFMMovementInteractorMock!
    var navigationControler: UINavigationControllerMock!
    var sdkDelegate: InvestplaySDKActionsSpy!
    var router: PFMMovementRouterMock!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        setupPFMMovementViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPFMMovementViewController() {
        sut = PFMMovementViewController()
        navigationControler = UINavigationControllerMock(rootViewController: sut)
        interactor = PFMMovementInteractorMock()
        router = PFMMovementRouterMock()
        sut.interactor = interactor
        sut.router = router

        sdkDelegate = InvestplaySDKActionsSpy()
        Investplay.delegate = sdkDelegate
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Tests

    func testShouldSetupViewAndDelegate() {
        // When
        loadView()

        // Then
        XCTAssertNotNil(sut.mainView.actionDelegate)
        XCTAssertTrue(sut.view is PFMMovementView)
    }

    func testShouldCallInteractor() {
        // Given
        let expectation = expectation(description: "Waiting for interactor")

        interactor.showMovementsCompletionHandler = { _ in
            expectation.fulfill()
        }

        // When
        loadView()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(interactor.wasShowMovementsCalled)
    }
    
    @MainActor func testDisplayMovementsMustSetupMainView() {
        // When
        sut.displayMovements(
            viewModel: PFMMovement.ShowMovements.ViewModel(
                filterDate: "testFilterDate",
                totalExpenses: "testTotalExpenses",
                updatedAt: "22-22-10",
                expenses: [:]
            )
        )
        
        // Then
        XCTAssertEqual(sut.mainView.balanceOfMonthValue.text, "testTotalExpenses")
        XCTAssertEqual(sut.mainView.type, .myExpenses)
    }
    
    @MainActor func testDisplayAllTransactionsMustSetupMainView() {
        // When
        sut.displayAllTransactions(
            viewModel: PFMMovement.ShowAllTransactions.ViewModel(
                filterDate: .empty,
                totalExits: .empty,
                totalEntries: .empty,
                total: .empty,
                updatedAt: .empty,
                movementTypeFilter: .movementTypeFilterTitle,
                expenses: [:]
            )
        )
        
        // Then
        XCTAssertEqual(sut.mainView.type, .allTransactions)
    }
    
    @MainActor func testDisplayModalMustCallRouter() {
        // Given
        let expectation = expectation(description: "Waiting for router")
        let vc = UIViewController()

        router.routeToFilterDateCompletionHandler = { viewController in
            XCTAssertEqual(viewController, vc)
            expectation.fulfill()
        }

        // When
        sut.displayModal(viewModel: PFMMovement.ShowModal.ViewModel(viewController: vc))

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(router.wasRouteToFilterDateCalled)
    }
    
    @MainActor func testDisplayTransactionDetailsMustCallRouter() {
        // Given
        let expectation = expectation(description: "Waiting for router")
        let vc = UIViewController()

        router.routeToTransactionDetailsCompletionHandler = {
            expectation.fulfill()
        }

        // When
        sut.displayTransactionDetails(viewModel: PFMMovement.TransactionDetails.ViewModel())

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(router.wasRouteToTransactionDetailsCalled)
    }
}
