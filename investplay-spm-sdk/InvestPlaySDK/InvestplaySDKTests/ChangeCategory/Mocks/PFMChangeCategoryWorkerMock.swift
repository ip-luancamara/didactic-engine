//
//  PFMChangeCategoryWorkerMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk
@testable import InvestplaySDK

class PFMChangeCategoryWorkerMock: PFMChangeCategoryWorkerProtocol {
        
    var getAllCategoriesCalled = false
    var changeCategoryCalled = false
    
    var getAllCategoriesCompletionHandler: ((GetCategoriesResult) -> Void)?
    var changeCategoryCompletionHandler: ((Transaction_, CategoryData) -> Void)?
    
    func getAllCategories(completion: @escaping GetCategoriesResult) {
        getAllCategoriesCalled = true
        getAllCategoriesCompletionHandler?(completion)
    }
    
    func changeCategory(transaction: Transaction_, to category: CategoryData, completion: @escaping (Result<Transaction_, PFMChangeCategoryWorkerError>) -> Void) {
        changeCategoryCalled = true
        changeCategoryCompletionHandler?(transaction, category)
    }
}
