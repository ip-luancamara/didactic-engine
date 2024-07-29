//
//  PFMChangeCategoryViewControllerTests.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import XCTest
@testable import InvestplaySDK

final class PFMChangeCategoryViewControllerTests: XCTestCase {

    // MARK: Subject under test
    var sut: PFMChangeCategoryViewController!

    var interactor: PFMChangeCategoryInteractorMock!
    var navigationControler: UINavigationControllerMock!
    var sdkDelegate: InvestplaySDKActionsSpy!
    var router: PFMChangeCategoryRouterMock!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        setupPFMChangeCategoryViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPFMChangeCategoryViewController() {
        sut = PFMChangeCategoryViewController()
        navigationControler = UINavigationControllerMock(rootViewController: sut)
        interactor = PFMChangeCategoryInteractorMock()
        router = PFMChangeCategoryRouterMock()
        sut.interactor = interactor
        sut.router = router

        sdkDelegate = InvestplaySDKActionsSpy()
        Investplay.delegate = sdkDelegate
    }
    
    func testLoadViewMustSetView() {
        // When
        sut.loadView()
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertTrue(sut.view is PFMChangeCategoryView)
    }

    func testViewDidLoadMustCallInteractor() {
        // Given
        let expectation = expectation(description: "waiting for Interactor to be called")
        
        interactor.getCategoriesCompletionHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(interactor.getCategoriesCalled)
    }
    
    @MainActor func testDisplayChangeCategoryWithSuccessMustCallRouter() {
        // Given
        let expectation = expectation(description: "waiting for Router to be called")
        
        router.routeToTransactionDetailsCompletionHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.displayChangeCategory(viewModel: .init(success: true))
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(router.routeToTransactionDetailsCalled)
    }
    
    @MainActor func testDisplayChangeCategoryWithFailureMustNotCallRouter() {
        // Given
        router.routeToTransactionDetailsCompletionHandler = { _ in
            XCTFail("Router should not be called")
        }
        
        // When
        sut.displayChangeCategory(viewModel: .init(success: false))
        
        // Then
        XCTAssertFalse(router.routeToTransactionDetailsCalled)
    }
    
    @MainActor func testDisplayCategoriesMustSetupView() {
        // Given
        sut.mainView.mainStack.isHidden = true
        
        // When
        sut.displayCategories(
            viewModel: .init(
                categories: [],
                selectedCategoryName: .empty
            )
        )
        
        // Then
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertFalse(sut.mainView.mainStack.isHidden)
    }
    
    @MainActor func testDisplayLoadingMustShowLoader() {
        // Given
        sut.mainView.isLoading = false
        
        // When
        sut.displayLoading(viewModel: .init())
        
        // Then
        XCTAssertTrue(sut.mainView.isLoading)
    }
}
