//
//  PFMServiceDetailsInteractorMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK
@testable import NetworkSdk

class PFMServiceDetailsInteractorMock: NSObject, PFMServiceDetailsBusinessLogic, PFMServiceDetailsDataStore, PFMServiceDetailsDelegate {
    
    var selectedTransaction: Transaction_?
    var dateFilter: InvestplaySDK.PFMDateFilter?
    var movementTypeFilter: TransactionType?
    var links: [Link] = []
    var spendings: Spendings?
    var transactions: TransactionsWithSummary?
    var serviceFilter: Service?

    var wasShowDetailsCalled = false
    var showDetailsCompletionHandler: ((PFMServiceDetails.ShowServiceDetails.Request) -> Void)?

    func showDetails(
        request: PFMServiceDetails.ShowServiceDetails.Request
    ) {
        wasShowDetailsCalled = true
        showDetailsCompletionHandler?(request)
    }

    func didTapServiceChip() {

    }

    func didTapDateChip() {

    }
    
    func didTapServiceChip(selectedID: String) {
        
    }
    
    func didTapDateChip(selectedMonth: Int, selectedYear: Int) {
        
    }
    
    func didTapMovementTypeChip(selected: InvestplaySDK.PFMMovementType?) {
        
    }
    
    func refetchData(request: InvestplaySDK.PFMServiceDetails.RefetchData.Request) {
        
    }
}
