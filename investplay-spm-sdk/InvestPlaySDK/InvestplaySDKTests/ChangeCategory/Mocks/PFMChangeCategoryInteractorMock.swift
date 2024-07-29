//
//  PFMChangeCategoryInteractorMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMChangeCategoryInteractorMock: PFMChangeCategoryBusinessLogic {
        
    var getCategoriesCalled = false
    
    var getCategoriesCompletionHandler: ((PFMChangeCategory.GetCategories.Request) -> Void)?
    
    var delegate: PFMChangeCategoryDelegate?
    
    func getCategories(request: PFMChangeCategory.GetCategories.Request) {
        getCategoriesCalled = true
        getCategoriesCompletionHandler?(request)
    }
}
