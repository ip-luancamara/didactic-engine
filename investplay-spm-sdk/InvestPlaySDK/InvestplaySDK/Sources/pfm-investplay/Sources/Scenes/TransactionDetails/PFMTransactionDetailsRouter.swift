//
//  PFMTransactionDetailsRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit

protocol PFMTransactionDetailsRoutingLogic {
    func routeToChangeCategory(delegate: PFMChangeCategoryDelegate)
}

protocol PFMTransactionDetailsDataPassing {
    var dataStore: PFMTransactionDetailsDataStore? { get }
}

class PFMTransactionDetailsRouter: NSObject, PFMTransactionDetailsRoutingLogic, PFMTransactionDetailsDataPassing {
    weak var viewController: PFMTransactionDetailsViewController?
    var dataStore: PFMTransactionDetailsDataStore?
    
    // MARK: Routing
    
    func routeToChangeCategory(
        delegate: PFMChangeCategoryDelegate
    ) {
        let destinationVC = PFMChangeCategoryViewController()
        destinationVC.delegate = viewController
        destinationVC.interactor?.delegate = delegate
        var destinationDS: (any PFMChangeCategoryDataStore)? = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func passData(source: PFMTransactionDetailsDataStore?, destination: inout PFMChangeCategoryDataStore?) {
        destination?.selectedTransaction = source?.selectedTransaction
    }
}
