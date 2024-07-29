//
//  PFMMovementRouterMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@testable import InvestplaySDK

class PFMMovementRouterMock: PFMMovementRoutingLogic, PFMMovementDataPassing {
    var dataStore: (any InvestplaySDK.PFMMovementDataStore)?
    
    var wasRouteToFilterDateCalled = false
    var wasRouteToTransactionDetailsCalled = false
    
    var routeToFilterDateCompletionHandler: ((UIViewController) -> Void)?
    var routeToTransactionDetailsCompletionHandler: (() -> Void)?
    
    func routeToFilterDate(modal: UIViewController) {
        wasRouteToFilterDateCalled = true
        routeToFilterDateCompletionHandler?(modal)
    }
    
    func routeToTransactionDetails() {
        wasRouteToTransactionDetailsCalled = true
        routeToTransactionDetailsCompletionHandler?()
    }
}
