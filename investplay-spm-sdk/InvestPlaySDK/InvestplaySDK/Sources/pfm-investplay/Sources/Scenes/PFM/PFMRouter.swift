//
//  PFMRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 11/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

protocol PFMDataPassing {
    var dataStore: PFMDataStore? { get }
}

protocol PFMRoutingLogic {
    func routeToServiceDetails()
    func routeToMovements(
        month: Int,
        year: Int
    )
    func routeToExpenses(
        month: Int,
        year: Int
    )
    func routeToFeedback(type: FeedbackType)
    func routeToTransactionsByCategory(
        month: Int,
        year: Int,
        categoryId: String
    )
}

class PFMRouter: PFMDataPassing {
    var dataStore: PFMDataStore?
    weak var viewController: PFMViewController?
}

extension PFMRouter: PFMRoutingLogic {
    
    func routeToServiceDetails() {
        let destinationVC = PFMServiceDetailsViewController()
        var destinationDS: (any PFMBaseDataStore)? = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToMovements(
        month: Int,
        year: Int) {
        let destinationVC = PFMMovementViewController()
        var destinationDS: (any PFMBaseDataStore)? = destinationVC.router?.dataStore
        destinationDS?.dateFilter = PFMDateFilter(month: month, year: year)
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToExpenses(
        month: Int,
        year: Int
    ) {
        let destinationVC = PFMExpensesViewController()
        var destinationDS: (any PFMBaseDataStore)? = destinationVC.router?.dataStore
        destinationDS?.dateFilter = PFMDateFilter(month: month, year: year)
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToFeedback(type: FeedbackType) {
        viewController?.navigationController?.pushViewController(
            PFMFeedbackViewController(
                type: type
            ),
            animated: true
        )
    }
    
    func routeToTransactionsByCategory(
        month: Int,
        year: Int,
        categoryId: String
    ) {
        let destinationVC = PFMCategoryTransactionsViewController()
        var destinationDS: (any PFMBaseDataStore)? = destinationVC.router?.dataStore
        var typedDestinationDS = destinationVC.router?.dataStore
        passData(source: dataStore, destination: &destinationDS)
        destinationDS?.dateFilter = PFMDateFilter(month: month, year: year)
        typedDestinationDS?.categoryFilter = categoryId
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func passData(source: PFMDataStore?, destination: inout PFMBaseDataStore?) {
        destination?.links = source?.links ?? []
        destination?.spendings = source?.spendings
        destination?.transactions = source?.transactions
        destination?.serviceFilter = source?.serviceFilter
    }
}
