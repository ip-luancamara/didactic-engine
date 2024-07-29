//
//  PFMTransactionDetailsPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit

protocol PFMTransactionDetailsPresentationLogic {
    func presentTransactionDetails(response: PFMTransactionDetails.TransactionDetails.Response)
    func presentChangeCategory(response: PFMTransactionDetails.ChangeCategory.Response)
    func presentIgnoredSpending(response: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Response)
}

class PFMTransactionDetailsPresenter: PFMTransactionDetailsPresentationLogic {
  weak var viewController: PFMTransactionDetailsDisplayLogic?
  
    func presentTransactionDetails(response: PFMTransactionDetails.TransactionDetails.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTransactionDetails(
                viewModel: PFMTransactionDetails.TransactionDetails.ViewModel(
                    type: response.type,
                    title: response.title,
                    value: response.value.formattedAsBRL(),
                    date: response.date.toFullString(),
                    fromTitle: response.fromTitle,
                    fromSubtitle: response.fromSubtitle,
                    fromImageURL: response.fromImageURL,
                    category: response.category,
                    isIgnored: response.isIgnored
                )
            )
        }
    }
    
    func presentChangeCategory(
        response: PFMTransactionDetails.ChangeCategory.Response
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayChangeCategory(
                viewModel: PFMTransactionDetails.ChangeCategory.ViewModel(
                    delegate: response.delegate
                )
            )
        }
    }
  
    func presentIgnoredSpending(
        response: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Response
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayChangedIgnoreSpendingFlag(
                viewModel: PFMTransactionDetails.ChangeIgnoreSpendingFlag.ViewModel(
                    success: response.success
                )
            )
        }
    }
}
