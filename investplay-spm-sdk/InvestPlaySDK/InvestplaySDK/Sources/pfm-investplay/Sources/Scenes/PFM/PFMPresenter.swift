//
//  PFMPresenter.swift
//
//
//  Created by Luan Câmara on 19/03/24.
//

import Foundation
import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

protocol PFMPresentationLogic {
    func presentLinks(response: PFM.LoadView.Response)
    func presentLoading()
    func presentSelectedService(response: PFM.SelectService.Response)
    func presentFeedback(response: PFM.Feedback.Response)
    func presentTransactionsByCategory(response: PFM.TransactionsByCategory.Response)
    func presentExpenses(response: PFM.AccessAll.Response)
    func presentMovements(response: PFM.Movements.Response)
    func presentModal(response: PFM.Modal.Response)
}

final class PFMPresenter: PFMPresentationLogic {

    let viewController: PFMDisplayLogic

    init(
        viewController: PFMDisplayLogic
    ) {
        self.viewController = viewController
    }

    func presentLinks(response: PFM.LoadView.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displayLinks(
                viewModel: PFM.LoadView.ViewModel(
                    accounts: response.services,
                    cards: response.cards,
                    allCardsBalance: response.allCardsBalance,
                    allAccountsBalance: response.allAccountsBalance,
                    insights: response.insights.map({
                        Insight(
                            title: $0.title,
                            description: $0.description,
                            iconName: $0.iconName,
                            icon: ImageAsset.getAsset(by: $0.iconName).image
                        )
                    }),
                    spendings: response.spendings.map({
                        SpendingCaroucelCardViewModel(
                            totalSpendings: $0.total.formattedAsBRL(),
                            headerSubtitle: "\($0.month) \($0.year)",
                            spendings: $0.spendings.enumerated().map({
                                PFMSpendingViewModel(
                                    categoryID: $0.element.id,
                                    title: $0.1.title,
                                    description: $0.1.value,
                                    icon: ImageAsset.getAsset(by: $0.1.icon.replacingOccurrences(of: "_", with: "-")).image,
                                    value: "\(Int($0.1.percentage)) %",
                                    percentage: $0.1.percentage,
                                    showDivider: $0.0 != 4,
                                    indicatorColor: $0.1.color
                                )
                            })
                        )
                    }),
                    charts: [
                        ChartsCarroucelCardViewModel(
                            type: .donut(color: response.spendingChartColor),
                            data: getDonutChartData(for: response.spendings.last),
                            threeMonthTotal: response.spendings.map({
                                $0.total
                            }).suffix(3).sum
                        ),
                        ChartsCarroucelCardViewModel(
                            type: .bars,
                            data: response.spendings.suffix(
                                3
                            ).map({
                                ChartData(
                                    value: $0.total,
                                    title: $0.total.formattedAsBRL(),
                                    subtitle: $0.month
                                )
                            }),
                            threeMonthTotal: response.spendings.map({
                                $0.total
                            }).sum
                        )
                    ]
                )
            )
        }
    }
    
    private func getDonutChartData(
        for data: MonthSpending?
    ) -> [ChartData] {
        guard let data, data.total > 0 else { 
            return [
                ChartData(
                    value: 0,
                    title: 0.formattedAsBRL(),
                    subtitle: getDonutSubtitle(for: data)
                )
            ]
        }
        
        return [
            ChartData(
                value: data.total,
                title: data.total.formattedAsBRL(),
                subtitle: getDonutSubtitle(
                    for: data
                )
            )
        ]
    }
    
    func presentFeedback(
        response: PFM.Feedback.Response
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            viewController.displayFeedbackView(
                viewModel: PFM.Feedback.ViewModel(
                    type: response.type
                )
            )
        }
    }

    private func getDonutSubtitle(for data: MonthSpending?) -> String {
        guard let data else { return .empty }
        return "\(data.shortMonth) \(data.year)"
    }

    func presentLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displayLoading()
        }
    }

    func presentSelectedService(response: PFM.SelectService.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displaySelectedService(viewModel: PFM.SelectService.ViewModel())
        }
    }
    
    func presentTransactionsByCategory(response: PFM.TransactionsByCategory.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displayTransactionsByCategory(
                viewModel: PFM.TransactionsByCategory.ViewModel(
                    month: response.month,
                    year: response.year,
                    categoryId: response.categoryId
                )
            )
        }
    }
    
    func presentExpenses(response: PFM.AccessAll.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displayExpenses(
                viewModel: PFM.AccessAll.ViewModel(
                    month: response.month,
                    year: response.year
                )
            )
        }
    }
    
    func presentMovements(response: PFM.Movements.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            viewController.displayMovements(
                viewModel: PFM.Movements.ViewModel(
                    month: response.month,
                    year: response.year
                )
            )
        }
    }
    
    func presentModal(response: PFM.Modal.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            viewController.displayModal(
                viewModel: PFM.Modal.ViewModel(
                    viewController: response.viewController
                )
            )
        }
    }
}
