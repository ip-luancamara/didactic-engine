//
//  PFMBusinessLogicSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK
@_implementationOnly import DesignSystem

class PFMBusinessLogicSpy: PFMBusinessLogic, UDSBalanceCreditCardViewModelDelegate, ChartsCarroucelDelegate, SpendingCarroucelDelegate {
    
    var getDataCalled = false
    var getDataCompletionHandler: ((PFM.LoadView.Request) -> Void)?

    func getData(request: PFM.LoadView.Request) {
        getDataCalled = true
        getDataCompletionHandler?(request)
    }

    func selectAccount(request: PFM.SelectService.Request) {

    }

    func didTapBalanceCreditCard(index: Int) {

    }
    
    func didTapAccessAll(request: InvestplaySDK.PFM.AccessAll.Request) {
        
    }
    
    func didTapChart(type: InvestplaySDK.DelegateChartType) {
        
    }
    
    func didSelectSpendingCard(at index: Int, categoryID: String) {
        
    }
}
