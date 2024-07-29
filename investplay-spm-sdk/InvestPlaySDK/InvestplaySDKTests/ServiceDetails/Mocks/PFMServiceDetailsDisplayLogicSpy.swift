//
//  PFMServiceDetailsDisplayLogicSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMServiceDetailsDisplayLogicSpy: PFMServiceDetailsDisplayLogic {

    var wasDisplayDetailsCalled = false
    var wasDisplayModalCalled = false

    var displayDetailsCompletion: ((PFMServiceDetails.ShowServiceDetails.ViewModel) -> Void)?
    var displayModalCompletion: ((PFMServiceDetails.ServiceModal.ViewModel) -> Void)?
    
    var wasDisplayTransactionDetailsCalled = false
    var displayTransactionDetailsCompletion: ((PFMServiceDetails.TransactionDetails.ViewModel) -> Void)?
    

    func displayDetails(
        viewModel: PFMServiceDetails.ShowServiceDetails.ViewModel
    ) {
        wasDisplayDetailsCalled = true
        displayDetailsCompletion?(viewModel)
    }

    func displayModal(
        viewModel: PFMServiceDetails.ServiceModal.ViewModel
    ) {
        wasDisplayModalCalled = true
        displayModalCompletion?(viewModel)
    }
    
    func displayTransactionDetails(viewModel: PFMServiceDetails.TransactionDetails.ViewModel) {
        wasDisplayTransactionDetailsCalled = true
        displayTransactionDetailsCompletion?(viewModel)
    }
}
