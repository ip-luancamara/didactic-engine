//
//  PFMDisplayLogicSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 04/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMDisplayLogicSpy: PFMDisplayLogic {

    var wasDisplayLinksCalled = false
    var wasDisplayLoadingCalled = false

    var displayLinksCompletionHandler: ((PFM.LoadView.ViewModel) -> Void)?
    var displayLoadingCompletionHandler: (() -> Void)?

    func displayLinks(viewModel: PFM.LoadView.ViewModel) {
        wasDisplayLinksCalled = true
        displayLinksCompletionHandler?(viewModel)
    }

    func displayLoading() {
        wasDisplayLoadingCalled = true
        displayLoadingCompletionHandler?()
    }

    func displaySelectedService(viewModel: PFM.SelectService.ViewModel) {

    }
    
    func displayFeedbackView(viewModel: InvestplaySDK.PFM.Feedback.ViewModel) {
        
    }
    
    func displayTransactionsByCategory(viewModel: InvestplaySDK.PFM.TransactionsByCategory.ViewModel) {
        
    }
    
    func displayExpenses(viewModel: InvestplaySDK.PFM.AccessAll.ViewModel) {
        
    }
    
    func displayMovements(viewModel: InvestplaySDK.PFM.Movements.ViewModel) {
        
    }
    
    func displayModal(viewModel: InvestplaySDK.PFM.Modal.ViewModel) {
        
    }
}
