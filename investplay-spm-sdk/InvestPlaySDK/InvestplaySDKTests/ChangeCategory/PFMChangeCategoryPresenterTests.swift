//
//  PFMChangeCategoryPresenterTests.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import XCTest
@testable import InvestplaySDK
@_implementationOnly import DesignSystem

final class PFMChangeCategoryPresenterTests: XCTestCase {

    // MARK: Subject under test
    var sut: PFMChangeCategoryPresenter!
    var viewController: PFMChangeCategoryDisplayLogicMock!
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
        viewController = PFMChangeCategoryDisplayLogicMock()
        sut = PFMChangeCategoryPresenter(viewController: viewController)
    }

    func testPresentCategoriesMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayCategories")
        
        viewController.displayCategoriesCompletionHandler = { viewModel in
            XCTAssertTrue(viewModel.categories.isEmpty)
            XCTAssertEqual(viewModel.selectedCategoryName, "Ifood")
            expectation.fulfill()
        }
        
        // When
        sut.presentCategories(
            response: PFMChangeCategory.GetCategories.Response(
                categories: [],
                selectedCategoryId: .empty,
                selectedCategoryName: "Ifood",
                delegate: DummyUDSSpendingActionViewModelDelegate()
            )
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayCategoriesCalled)
    }
    
    func testPresentChangeCategoryMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayChangeCategory")
        
        viewController.displayChangeCategoryCompletionHandler = { viewModel in
            XCTAssertTrue(viewModel.success)
            expectation.fulfill()
        }
        
        // When
        sut.presentChangeCategory(
            response: PFMChangeCategory.ChangeCategory.Response(success: true)
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayChangeCategoryCalled)
    }
    
    func testPresentLoadingMustCallViewController() {
        // Given
        let expectation = expectation(description: "Expected to call displayLoading")
        
        viewController.displayLoadingCompletionHandler = { _ in

            expectation.fulfill()
        }
        
        // When
        sut.presentLoading(
            response: PFMChangeCategory.Loading.Response()
        )
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewController.displayLoadingCalled)
    }
    
    private class DummyUDSSpendingActionViewModelDelegate: UDSSpendingActionViewModelDelegate {
        func didTapView(sender: DesignSystem.UDSSpendingAction) { }
    }
    
}
