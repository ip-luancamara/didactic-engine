//
//  PFMMovementInteractorMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 15/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMMovementInteractorMock: PFMMovementBusinessLogic, PFMMovementViewDelegate {
    
    var wasShowMovementsCalled = false
    var showMovementsCompletionHandler: ((PFMMovement.ShowMovements.Request) -> Void)?
    
    func showMovements(request: InvestplaySDK.PFMMovement.ShowMovements.Request) {
        wasShowMovementsCalled = true
        showMovementsCompletionHandler?(request)
    }
    
    func didTapDateChip() { }
    func didTapMovementTypeChip() { }
    func didSelect(tab: PFMMovementViewType) { }
}
