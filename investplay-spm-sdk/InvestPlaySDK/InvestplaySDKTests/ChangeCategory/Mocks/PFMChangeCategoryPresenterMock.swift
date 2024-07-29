//
//  PFMChangeCategoryPresenterMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMChangeCategoryPresenterMock: PFMChangeCategoryPresentationLogic {
        
    var presentCategoriesCalled = false
    var presentChangeCategoryCalled = false
    var presentLoadingCalled = false
    
    var presentCategoriesCompletionHandler: ((PFMChangeCategory.GetCategories.Response) -> Void)?
    var presentChangeCategoryCompletionHandler: ((PFMChangeCategory.ChangeCategory.Response) -> Void)?
    var presentLoadingCompletionHandler: ((PFMChangeCategory.Loading.Response) -> Void)?
    
    func presentCategories(response: PFMChangeCategory.GetCategories.Response) {
        presentCategoriesCalled = true
        presentCategoriesCompletionHandler?(response)
    }
    
    func presentChangeCategory(response: PFMChangeCategory.ChangeCategory.Response) {
        presentChangeCategoryCalled = true
        presentChangeCategoryCompletionHandler?(response)
    }
    
    func presentLoading(response: PFMChangeCategory.Loading.Response) {
        presentLoadingCalled = true
        presentLoadingCompletionHandler?(response)
    }
}
