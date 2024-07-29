//
//  PFMServiceDetailsPresentationLogicSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMServiceDetailsPresentationLogicSpy: PFMServiceDetailsPresentationLogic {

    var wasPresentDetailsCalled = false
    var wasPresentSelectModalCalled = false

    var presentDetailsCompletion: ((PFMServiceDetails.ShowServiceDetails.Response) -> Void)?
    var presentSelectModalCompletion: ((PFMServiceDetails.ServiceModal.Response) -> Void)?

    func presentDetails(
        response: PFMServiceDetails.ShowServiceDetails.Response
    ) {
        wasPresentDetailsCalled = true
        presentDetailsCompletion?(response)
    }

    func presentSelectModal(
        response: PFMServiceDetails.ServiceModal.Response
    ) {
        wasPresentSelectModalCalled = true
        presentSelectModalCompletion?(response)
    }
    
    func presentTransactionDetails(response: PFMServiceDetails.TransactionDetails.Response) {
        
    }
}
