//
//  PFMExpensesRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 15/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

protocol PFMExpensesRoutingLogic {
    func routeToFilterDate(modal: UIViewController)
    func routeToTransactionsByCategory(categoryId: String)
}

protocol PFMExpensesDataPassing {
    var dataStore: PFMExpensesDataStore? { get }
}

class PFMExpensesRouter: PFMExpensesRoutingLogic, PFMExpensesDataPassing {

    weak var viewController: PFMExpensesViewController?
    
    var dataStore: PFMExpensesDataStore?

    // MARK: Navigation
    
    func routeToFilterDate(modal: UIViewController) {
        viewController?.present(modal, animated: false)
    }
    
    func routeToTransactionsByCategory(
        categoryId: String
    ) {
        let destinationVC = PFMCategoryTransactionsViewController()
        var destinationDS: (any PFMBaseDataStore)? = destinationVC.router?.dataStore
        var typedDestinationDS = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        typedDestinationDS?.categoryFilter = categoryId
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Communication
    
    private func passData(source: PFMExpensesDataStore?, destination: inout PFMBaseDataStore?) {
        destination?.links = source?.links ?? []
        destination?.spendings = source?.spendings
        destination?.transactions = source?.transactions
        destination?.serviceFilter = source?.serviceFilter
        destination?.dateFilter = source?.dateFilter
    }
}

