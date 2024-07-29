//
//  PFMCategoryTransactionsPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation

protocol PFMCategoryTransactionsPresentationLogic {
    func presentMovements(response: PFMCategoryTransactions.ShowMovements.Response)
    func presentTransactionDetails(response: PFMCategoryTransactions.TransactionDetails.Response)
}

class PFMCategoryTransactionsPresenter: PFMCategoryTransactionsPresentationLogic {
    let viewController: PFMCategoryTransactionsDisplayLogic

    init(viewController: PFMCategoryTransactionsDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentMovements(response: PFMCategoryTransactions.ShowMovements.Response) {
        let viewModel = PFMCategoryTransactions.ShowMovements.ViewModel(
            filterDate: "\(Calendar.ptBR.monthSymbols[response.filterDate.month - 1].capitalized) de \(response.filterDate.year)",
            totalExpenses: response.totalExpenses.formattedAsBRL(),
            expenses: response.expenses,
            selectedCategory: response.selectedCategory
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayMovements(viewModel: viewModel)
        }
    }
    
    func presentTransactionDetails(response: PFMCategoryTransactions.TransactionDetails.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayTransactionDetails(viewModel: PFMCategoryTransactions.TransactionDetails.ViewModel())
        }
    }
}
