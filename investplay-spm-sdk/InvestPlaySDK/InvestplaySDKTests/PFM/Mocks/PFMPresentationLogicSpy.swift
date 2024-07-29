//
//  PFMPresentationLogicSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMPresentationLogicSpy: PFMPresentationLogic {

    var wasPresentLinksCalled = false
    var wasPresentLoadingCalled = false

    var presentLinksCompletionHandler: ((InvestplaySDK.PFM.LoadView.Response) -> Void)?
    var presentLoadingCompletionHandler: (() -> Void)?

    func presentLinks(response: InvestplaySDK.PFM.LoadView.Response) {
        wasPresentLinksCalled = true
        presentLinksCompletionHandler?(response)
    }

    func presentLoading() {
        wasPresentLoadingCalled = true
        presentLoadingCompletionHandler?()
    }

    func presentSelectedService(response: InvestplaySDK.PFM.SelectService.Response) {

    }
    
    func presentFeedback(response: InvestplaySDK.PFM.Feedback.Response) {
        
    }
    
    func presentTransactionsByCategory(response: InvestplaySDK.PFM.TransactionsByCategory.Response) {
        
    }
    
    func presentExpenses(response: InvestplaySDK.PFM.AccessAll.Response) {
        
    }
    
    func presentMovements(response: InvestplaySDK.PFM.Movements.Response) {
        
    }
    
    func presentModal(response: InvestplaySDK.PFM.Modal.Response) {
        
    }

}
