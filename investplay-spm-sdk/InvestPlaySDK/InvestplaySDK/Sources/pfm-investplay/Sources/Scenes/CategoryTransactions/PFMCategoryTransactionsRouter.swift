//
//  PFMCategoryTransactionsRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

protocol PFMCategoryTransactionsRoutingLogic {
    func routeToTransactionDetails()
}

protocol PFMCategoryTransactionsDataPassing {
    var dataStore: PFMCategoryTransactionsDataStore? { get }
}

class PFMCategoryTransactionsRouter: PFMCategoryTransactionsRoutingLogic, PFMCategoryTransactionsDataPassing {

    weak var viewController: PFMCategoryTransactionsViewController?
    
    var dataStore: PFMCategoryTransactionsDataStore?

    // MARK: Navigation
    
    func routeToTransactionDetails() {
        let destinationVC = PFMTransactionDetailsViewController()
        var destinationDS: (any PFMTransactionDetailsDataStore)? = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Communication
    
    private func passData(
        source: PFMCategoryTransactionsDataStore?,
        destination: inout PFMTransactionDetailsDataStore?
    ) {
        guard let selectedTransaction = source?.selectedTransaction else { return }
        destination?.selectedTransaction = selectedTransaction
        destination?.links = source?.links ?? []
    }

}
