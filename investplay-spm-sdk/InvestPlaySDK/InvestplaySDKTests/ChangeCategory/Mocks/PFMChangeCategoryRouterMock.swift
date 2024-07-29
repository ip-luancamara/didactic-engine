//
//  PFMChangeCategoryRouterMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMChangeCategoryRouterMock: NSObject, PFMChangeCategoryRoutingLogic, PFMChangeCategoryDataPassing {
    
    var dataStore: PFMChangeCategoryDataStore?

    var routeToTransactionDetailsCalled = false
    var routeToTransactionDetailsCompletionHandler: (((() -> Void)?) -> Void)?
    
    func routeToTransactionDetails(completion: (() -> Void)?) {
        routeToTransactionDetailsCalled = true
        routeToTransactionDetailsCompletionHandler?(completion)
    }
    
}
