//
//  PFMServiceDetailsPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 11/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem

protocol PFMServiceDetailsPresentationLogic {
    func presentDetails(response: PFMServiceDetails.ShowServiceDetails.Response)
    func presentSelectModal(response: PFMServiceDetails.ServiceModal.Response)
    func presentTransactionDetails(response: PFMServiceDetails.TransactionDetails.Response)
}

class PFMServiceDetailsPresenter: PFMServiceDetailsPresentationLogic {

    let viewController: PFMServiceDetailsDisplayLogic

    init(viewController: PFMServiceDetailsDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: Presentation logic

    func presentDetails(response: PFMServiceDetails.ShowServiceDetails.Response) {
        var movementFilterTitle: I18n
        
        switch response.movementFilter {
        case .debit:
            movementFilterTitle = .exits
        case .credit:
            movementFilterTitle = .entries
        default:
            movementFilterTitle = .movimentationType
        }
        
        let viewModel = PFMServiceDetails.ShowServiceDetails.ViewModel(
            type: response.type,
            screenTitle: response.screenTitle.localized,
            month: response.selectedMonth,
            year: response.selectedYear,
            transactions: response.transactions,
            totalEntries: response.totalEntries.formattedAsBRL(),
            totalExits: response.totalExits.formattedAsBRL(),
            balance: response.balance.formattedAsBRL(),
            updatedAt: response.updatedAt.toUpdatedAt(),
            movementFilterTitle: movementFilterTitle
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayDetails(viewModel: viewModel)
        }
    }

    func presentSelectModal(response: PFMServiceDetails.ServiceModal.Response) {
        let viewModel = PFMServiceDetails.ServiceModal.ViewModel(viewController: response.viewController)

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayModal(viewModel: viewModel)
        }
    }
    
    func presentTransactionDetails(response: PFMServiceDetails.TransactionDetails.Response) {
        let viewModel = PFMServiceDetails.TransactionDetails.ViewModel()

        DispatchQueue.main.async { [weak self] in
            self?.viewController.displayTransactionDetails(viewModel: viewModel)
        }
    }
}
