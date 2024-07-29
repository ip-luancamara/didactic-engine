//
//  PFMMovementPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk

protocol PFMMovementPresentationLogic {
    func presentMovements(response: PFMMovement.ShowMovements.Response)
    func presentModal(response: PFMMovement.ShowModal.Response)
    func presentAllTransactions(response: PFMMovement.ShowAllTransactions.Response)
    func presentTransactionDetails(response: PFMMovement.TransactionDetails.Response)
}

class PFMMovementPresenter: PFMMovementPresentationLogic {
    let viewController: PFMMovementDisplayLogic

    init(viewController: PFMMovementDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentMovements(response: PFMMovement.ShowMovements.Response) {
        let viewModel = PFMMovement.ShowMovements.ViewModel(
            filterDate: "\(Calendar.ptBR.monthSymbols[response.filterDate.month - 1].capitalized) de \(response.filterDate.year)",
            totalExpenses: response.totalExpenses.formattedAsBRL(),
            updatedAt: response.updatedAt.toUpdatedAt(),
            expenses: response.expenses
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayMovements(viewModel: viewModel)
        }
    }
    
    func presentModal(response: PFMMovement.ShowModal.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayModal(
                viewModel: PFMMovement.ShowModal.ViewModel(
                    viewController: response.viewController
                )
            )
        }
    }
    
    func presentAllTransactions(response: PFMMovement.ShowAllTransactions.Response) {
        let viewModel = PFMMovement.ShowAllTransactions.ViewModel(
            filterDate: "\(Calendar.ptBR.monthSymbols[response.filterDate.month - 1].capitalized) de \(response.filterDate.year)",
            totalExits: response.totalExits.formattedAsBRL(),
            totalEntries: response.totalEntries.formattedAsBRL(),
            total: (response.totalEntries + response.totalExits).formattedAsBRL(),
            updatedAt: response.updatedAt.toUpdatedAt(),
            movementTypeFilter: getTitle(for: response.movementTypeFilter),
            expenses: response.expenses
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayAllTransactions(viewModel: viewModel)
        }
    }
    
    func presentTransactionDetails(response: PFMMovement.TransactionDetails.Response) {
        let viewModel = PFMMovement.TransactionDetails.ViewModel()

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayTransactionDetails(viewModel: viewModel)
        }
    }
    
    private func getTitle(for movementType: TransactionType?) -> I18n {
        guard let movementType else { return .movimentationType }
        switch movementType {
        case .credit:
            return .entries
        case .debit:
            return .exits
        default:
            return .movimentationType
        }
    }
}
