//
//  PFMViewControllerTests.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

@testable import InvestplaySDK
import XCTest

class PFMViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: PFMViewController!
    var window: UIWindow!
    var spy: PFMBusinessLogicSpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPFMViewController()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPFMViewController() {
        sut = PFMViewController()
        spy = PFMBusinessLogicSpy()
        sut.interactor = spy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Tests
    
    @MainActor func testDisplaySomething() {
        // Given
        let viewModel = PFM.LoadView.ViewModel(
            accounts: [],
            cards: [],
            allCardsBalance: 1000,
            allAccountsBalance: 1000,
            insights: [],
            spendings: [],
            charts: []
        )

        sut.mainView.isLoading = true

        // When
        loadView()
        sut.displayLinks(viewModel: viewModel)

        // Then
        XCTAssertFalse(sut.mainView.isLoading)
    }
}
