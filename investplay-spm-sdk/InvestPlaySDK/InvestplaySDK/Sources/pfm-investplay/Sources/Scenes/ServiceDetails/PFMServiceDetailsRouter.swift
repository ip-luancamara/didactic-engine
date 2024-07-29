//
//  PFMServiceDetailsRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 11/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

import UIKit

protocol PFMServiceDetailsRoutingLogic {
    func routeToTransactionDetails()
}

protocol PFMServiceDetailsDataPassing {
    var dataStore: PFMServiceDetailsDataStore? { get }
}

class PFMServiceDetailsRouter: PFMServiceDetailsRoutingLogic, PFMServiceDetailsDataPassing {

    weak var viewController: PFMServiceDetailsViewController?
    var dataStore: PFMServiceDetailsDataStore?

    // MARK: Navigation
    
    func routeToTransactionDetails() {
        let destinationVC = PFMTransactionDetailsViewController()
        var destinationDS: (any PFMTransactionDetailsDataStore)? = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Communication
    
    private func passData(source: PFMServiceDetailsDataStore?, destination: inout PFMTransactionDetailsDataStore?) {
        guard let selectedTransaction = source?.selectedTransaction else { return }
        destination?.selectedTransaction = selectedTransaction
        destination?.links = source?.links ?? []
    }
}
