//
//  PFMExpensesInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 07/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

protocol PFMExpensesBusinessLogic {
    func showCategories(request: PFMExpenses.ShowCategories.Request)
}

protocol PFMExpensesDataStore: PFMBaseDataStore {

}

class PFMExpensesInteractor: PFMExpensesBusinessLogic, PFMExpensesDataStore {
    
    var links: [Link] = []
    var spendings: (any Spendings)?
    var transactions: TransactionsWithSummary?

    var serviceFilter: Service?
    var dateFilter: PFMDateFilter?
    var movementTypeFilter: TransactionType?
    
    let presenter: PFMExpensesPresentationLogic

    init(
        presenter: PFMExpensesPresentationLogic
    ) {
        self.presenter = presenter
    }
    
    func showCategories(request: PFMExpenses.ShowCategories.Request) {
        if dateFilter == nil {
            dateFilter = PFMDateFilter(month: Date().month.toInt, year: Date().year.toInt)
        }
        
        guard let dateFilter else { return }
        
        let isCurrentDate = dateFilter.month == Date().month.toInt && dateFilter.year == Date().year.toInt
        
        let monthlyExpending = isCurrentDate
            ? spendings?.currentMonth
            : spendings?.previousMonths.first { $0.monthIndex_ == dateFilter.month && $0.year == dateFilter.year }
        
        guard let monthlyExpending else { return }
        
        let filteredSpendingsByCategories = monthlyExpending.allSpendingsByCategories.filter({ $0.amount != 0 })
        
        presenter.presentCategories(
            response: PFMExpenses.ShowCategories.Response(
                filterDate: dateFilter,
                totalExpenses: monthlyExpending.amount,
                categories: filteredSpendingsByCategories.enumerated().map {
                    (
                        getSpendingChartModel(
                            with: $0.element,
                            showDivider: $0.offset != filteredSpendingsByCategories.endIndex - 1
                        ),
                        $0.element.category?.id ?? .empty
                    )
                }
            )
        )
    }
    
    func getSpendingChartModel(
        with spending: SpendingsByCategory,
        showDivider: Bool
    ) -> UDSSpendingChartModel {
        UDSSpendingChartModel(
            icon: .getUDSImage(with: spending.category?.iconName ?? "") ?? .init(),
            chartBarConfig: UDSChartBarLimitModel(
                titleLeftText: spending.category?.localization?.ptBR,
                titleRightText: "Transações: \(spending.transactionIds.count)",
                progressBarConfig: UDSProgressBarModel(
                    progressTintColor: UIColor(hexString: spending.category?.color),
                    trackTintColor: UDSColors.grey100.color,
                    value: Float(spending.percentage_ / 100)
                ),
                subtitleLeftText: spending.amount.formattedAsBRL(),
                subtitleRightText: "\(spending.percentage_) %"
            ),
            showDivider: showDivider,
            indicatorColor: UIColor(hexString: spending.category?.color)
        )
    }
}

extension PFMExpensesInteractor: PFMExpensesViewDelegate {
    func didTapFilterButton() {
        let bottomSheetViewController = PFMItemSelectionViewController(
            type: .date,
            selectedYear: dateFilter?.year ?? Date().year.toInt,
            selectedMonth: dateFilter?.month ?? Date().month.toInt
        )
        
        bottomSheetViewController.delegate = self

        let modalViewController = UDSBottomSheetViewController(
            viewModel: UDSBottomSheetViewModel(
                childViewController: bottomSheetViewController
            )
        )

        bottomSheetViewController.dismiss = {
            modalViewController.dismiss(animated: true)
        }

        presenter.presentDateSelectModal(
            response: PFMExpenses.FilterDate.Response(
                viewController: modalViewController
            )
        )
    }
}

extension PFMExpensesInteractor: PFMItemSelectionDelegate {
    func didSelect(
        month: Int,
        year: Int
    ) {
        dateFilter = PFMDateFilter(month: month, year: year)
        showCategories(request: PFMExpenses.ShowCategories.Request())
    }
}
