//
//  PFMMovementRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

protocol PFMMovementRoutingLogic {
    func routeToFilterDate(modal: UIViewController)
    func routeToTransactionDetails()
}

protocol PFMMovementDataPassing {
    var dataStore: PFMMovementDataStore? { get }
}

class PFMMovementRouter: PFMMovementRoutingLogic, PFMMovementDataPassing {

    weak var viewController: PFMMovementViewController?
    
    var dataStore: PFMMovementDataStore?

    // MARK: Navigation
    func routeToFilterDate(modal: UIViewController) {
        viewController?.present(modal, animated: false)
    }

    func routeToTransactionDetails() {
        let destinationVC = PFMTransactionDetailsViewController()
        var destinationDS: (any PFMTransactionDetailsDataStore)? = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Communication
    
    private func passData(
        source: PFMMovementDataStore?,
        destination: inout PFMTransactionDetailsDataStore?
    ) {
        guard let selectedTransaction = source?.selectedTransaction else { return }
        destination?.selectedTransaction = selectedTransaction
        destination?.links = source?.links ?? []
    }

}
