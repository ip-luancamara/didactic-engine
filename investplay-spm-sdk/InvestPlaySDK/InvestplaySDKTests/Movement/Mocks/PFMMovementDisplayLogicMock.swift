//
//  PFMMovementDisplayLogicMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMMovementDisplayLogicMock: PFMMovementDisplayLogic {
    
    var displayMovementsCalled = false
    var displayModalCalled = false
    var displayAllTransactionsCalled = false
    var displayTransactionDetailsCalled = false
    
    var displayMovementsCompletionHandler: ((PFMMovement.ShowMovements.ViewModel) -> Void)?
    var displayModalCompletionHandler: ((PFMMovement.ShowModal.ViewModel) -> Void)?
    var displayAllTransactionsCompletionHandler: ((PFMMovement.ShowAllTransactions.ViewModel) -> Void)?
    var displayTransactionDetailsCompletionHandler: ((PFMMovement.TransactionDetails.ViewModel) -> Void)?
    
    func displayMovements(viewModel: InvestplaySDK.PFMMovement.ShowMovements.ViewModel) {
        displayMovementsCalled = true
        displayMovementsCompletionHandler?(viewModel)
    }
    
    func displayModal(viewModel: InvestplaySDK.PFMMovement.ShowModal.ViewModel) {
        displayModalCalled = true
        displayModalCompletionHandler?(viewModel)
    }
    
    func displayAllTransactions(viewModel: InvestplaySDK.PFMMovement.ShowAllTransactions.ViewModel) {
        displayAllTransactionsCalled = true
        displayAllTransactionsCompletionHandler?(viewModel)
    }
    
    func displayTransactionDetails(viewModel: InvestplaySDK.PFMMovement.TransactionDetails.ViewModel) {
        displayTransactionDetailsCalled = true
        displayTransactionDetailsCompletionHandler?(viewModel)
    }
}
