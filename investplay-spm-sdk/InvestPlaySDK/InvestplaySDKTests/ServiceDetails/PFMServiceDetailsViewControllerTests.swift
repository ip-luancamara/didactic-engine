//
//  PFMServiceDetailsViewControllerTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


@testable import InvestplaySDK
import XCTest

class PFMServiceDetailsViewControllerTests: XCTestCase {

    // MARK: Subject under test
    var sut: PFMServiceDetailsViewController!

    var interactor: PFMServiceDetailsInteractorMock!
    var navigationControler: UINavigationControllerMock!
    var sdkDelegate: InvestplaySDKActionsSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        setupPFMServiceDetailsViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPFMServiceDetailsViewController() {
        sut = PFMServiceDetailsViewController()
        navigationControler = UINavigationControllerMock(rootViewController: sut)
        interactor = PFMServiceDetailsInteractorMock()
        sut.interactor = interactor

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
        XCTAssertTrue(sut.view is PFMServiceDetailsView)
    }

    func testShouldCallInteractor() {
        // Given
        let expectation = expectation(description: "Waiting for interactor")

        interactor.showDetailsCompletionHandler = { _ in
            expectation.fulfill()
        }

        // When
        loadView()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(interactor.wasShowDetailsCalled)
    }

    @MainActor func testDisplayDetailsMustSetTitle() {
        // When
        sut.displayDetails(
            viewModel: PFMServiceDetails.ShowServiceDetails.ViewModel(
                type: .account(
                    Account(
                        id: "1",
                        bankName: "Nubank",
                        imageURL: "",
                        accountNumber: "123",
                        balance: "500,00"
                    )
                ),
                screenTitle: "TestTitle",
                month: 1,
                year: 1,
                transactions: [:],
                totalEntries: .empty,
                totalExits: .empty,
                balance: .empty,
                updatedAt: .empty,
                movementFilterTitle: .filter
            )
        )

        // Then
        XCTAssertEqual(sut.titleView.text, "TestTitle")
    }

    @MainActor func testDisplayModalMustPresentViewController() {
        // Given
        let viewController = UIViewController()

        window.addSubview(navigationControler.view)
        RunLoop.current.run(until: Date())

        // When
        sut.displayModal(viewModel: PFMServiceDetails.ServiceModal.ViewModel(viewController: viewController))

        // Then
        XCTAssertNotNil(sut.presentedViewController)
    }
}
