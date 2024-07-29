//
//  PFMMovementPresenterMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMMovementPresenterMock: PFMMovementPresentationLogic {

    var presentMovementsCalled = false
    var presentModalCalled = false
    var presentAllTransactionsCalled = false
    var presentTransactionDetailsCalled = false
    
    var presentMovementsCompletionHandler: ((PFMMovement.ShowMovements.Response) -> Void)?
    var presentModalCompletionHandler: ((PFMMovement.ShowModal.Response) -> Void)?
    var presentAllTransactionsCompletionHandler: ((PFMMovement.ShowAllTransactions.Response) -> Void)?
    var presentTransactionDetailsCompletionHandler: ((PFMMovement.TransactionDetails.Response) -> Void)?

    func presentMovements(response: PFMMovement.ShowMovements.Response) {
        presentMovementsCalled = true
        presentMovementsCompletionHandler?(response)
    }
    
    func presentModal(response: PFMMovement.ShowModal.Response) {
        presentModalCalled = true
        presentModalCompletionHandler?(response)
    }
    
    func presentAllTransactions(response: PFMMovement.ShowAllTransactions.Response) {
        presentAllTransactionsCalled = true
        presentAllTransactionsCompletionHandler?(response)
    }
    
    func presentTransactionDetails(response: PFMMovement.TransactionDetails.Response) {
        presentTransactionDetailsCalled = true
        presentTransactionDetailsCompletionHandler?(response)
    }
}
