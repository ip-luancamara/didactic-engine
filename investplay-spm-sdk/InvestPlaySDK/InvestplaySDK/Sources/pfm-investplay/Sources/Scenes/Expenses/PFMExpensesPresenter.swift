//
//  PFMExpensesPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 07/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation

protocol PFMExpensesPresentationLogic {
    func presentCategories(response: PFMExpenses.ShowCategories.Response)
    func presentDateSelectModal(response: PFMExpenses.FilterDate.Response)
}

class PFMExpensesPresenter: PFMExpensesPresentationLogic {
    let viewController: PFMExpensesDisplayLogic

    init(
        viewController: PFMExpensesDisplayLogic
    ) {
        self.viewController = viewController
    }
    
    func presentCategories(
        response: PFMExpenses.ShowCategories.Response
    ) {
        viewController.displayCategories(
            viewModel: PFMExpenses.ShowCategories.ViewModel(
                filterDate: "\(Calendar.ptBR.monthSymbols[response.filterDate.month - 1].capitalized) de \(response.filterDate.year)",
                totalExpenses: response.totalExpenses.formattedAsBRL(),
                categories: response.categories
            )
        )
    }
    
    
    func presentDateSelectModal(response: PFMExpenses.FilterDate.Response) {
        viewController.displayDateSelectModal(
            viewModel: PFMExpenses.FilterDate.ViewModel(
                viewController: response.viewController
            )
        )
    }
}
