//
//  PFMChangeCategoryDisplayLogicMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMChangeCategoryDisplayLogicMock: PFMChangeCategoryDisplayLogic {
    
    var displayChangeCategoryCalled = false
    var displayCategoriesCalled = false
    var displayLoadingCalled = false
    
    var displayChangeCategoryCompletionHandler: ((PFMChangeCategory.ChangeCategory.ViewModel) -> Void)?
    var displayCategoriesCompletionHandler: ((PFMChangeCategory.GetCategories.ViewModel) -> Void)?
    var displayLoadingCompletionHandler: ((PFMChangeCategory.Loading.ViewModel) -> Void)?
    
    func displayChangeCategory(viewModel: PFMChangeCategory.ChangeCategory.ViewModel) {
        displayChangeCategoryCalled = true
        displayChangeCategoryCompletionHandler?(viewModel)
    }
    
    func displayCategories(viewModel: PFMChangeCategory.GetCategories.ViewModel) {
        displayCategoriesCalled = true
        displayCategoriesCompletionHandler?(viewModel)
    }
    
    func displayLoading(viewModel: PFMChangeCategory.Loading.ViewModel) {
        displayLoadingCalled = true
        displayLoadingCompletionHandler?(viewModel)
    }
}
