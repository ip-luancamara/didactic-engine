//
//  PFMInteractor.swift
//
//
//  Created by Luan Câmara on 19/03/24.
//

import Foundation
import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

protocol PFMDataStore: PFMBaseDataStore { }

protocol PFMBusinessLogic {
    func getData(request: PFM.LoadView.Request)
    func selectAccount(request: PFM.SelectService.Request)
    func didTapAccessAll(request: PFM.AccessAll.Request)
}

final class PFMInteractor: PFMBusinessLogic, PFMDataStore {

    let worker: PFMWorkerProtocol
    let presenter: PFMPresentationLogic
    let logger: PFMLoggerProtocol

    var links: [Link] = []
    var spendings: Spendings?
    var transactions: TransactionsWithSummary?
    
    var serviceFilter: Service?
    var dateFilter: PFMDateFilter?
    var movementTypeFilter: TransactionType?

    init(
        worker: PFMWorkerProtocol = PFMWorker(),
        presenter: PFMPresentationLogic,
        logger: PFMLoggerProtocol = PFMLogger(className: PFMWorker.self)
    ) {
        self.worker = worker
        self.presenter = presenter
        self.logger = logger
        
        presenter.presentLoading()
    }
    
    func clearFilters() {
        serviceFilter = nil
        dateFilter = nil
        movementTypeFilter = nil
    }

    func getData(request: PFM.LoadView.Request) {
        clearFilters()
        
        logger.log("Requesting presenter to present loading")

        let group = DispatchGroup()
        
        var hasError: PFMWorkerError?

        logger.log("Requesting worker to get links")
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            worker.getLinks { result in
                switch result {
                case .success(let links):
                    self.links = links
                case .failure(let error):
                    hasError = error
                }

                group.leave()
            }
        }

        logger.log("Requesting worker to get spendings")
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            worker.getSpendings { result in
                switch result {
                case .success(let spendings):
                    self.spendings = spendings
                case .failure(let error):
                    hasError = error
                }

                group.leave()
            }
        }

        logger.log("Requesting worker to get transactions")
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            worker.getTransactions { result in
                switch result {
                case .success(let transactions):
                    self.transactions = transactions
                case .failure(let error):
                    hasError = error
                }

                group.leave()
            }
        }

        group.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let self else { return }
            
            if let hasError {
                logger.log("Requesting presenter to present error feedback")
                presenter.presentFeedback(response: PFM.Feedback.Response(type: .unknown))
                return
            }

            logger.log("Requesting presenter to present links")
            presenter.presentLinks(
                response: PFM.LoadView.Response(
                    services: self.getAccounts(),
                    cards: self.getCreditCards(),
                    allCardsBalance: self.creditCardsBalance,
                    allAccountsBalance: self.accountsBalance,
                    insights: self.getInsights(),
                    spendings: self.getSpendings(),
                    spendingChartColor: self.spendings?.spendingsLevel?.data.spendingsLevelColor?.color ?? .clear
                )
            )
        }
    }

    func selectAccount(request: PFM.SelectService.Request) {
        serviceFilter = accounts[request.index]

        logger.log("Requesting presenter to present selected service")
        presenter.presentSelectedService(
            response: PFM.SelectService.Response()
        )
    }

    private func getAccounts() -> [Account] {
        accounts.map {
            Account(
                id: $0.id,
                bankName: getLink(
                    id: $0.linkId
                )?.brand.name ?? "",
                imageURL: getLink(
                    id: $0.linkId
                )?.brand.imageUrl ?? "",
                accountNumber: $0.accountData?.displayNumber ?? "",
                balance: ($0.accountData?.balance ?? 0).formattedAsBRL()
            )
        }
    }

    private func getCreditCards() -> [CreditCard] {
        creditCards.compactMap({ card in
            guard let link = getLink(id: card.linkId), let data = card.creditCardData else { return nil }
            let previousBill = data.previousBill?.totalAmount ?? 0
            return CreditCard(
                id: card.id,
                level: data.level?.capitalized ?? "",
                image: getImage(for: data.brand),
                limit: (data.availableCreditLimit?.doubleValue ?? 0).formattedAsBRL(),
                currentStatement: data.balance.formattedAsBRL(),
                dueDate: data.balanceDueDate?.toDate().toCreditCardDueDate() ?? "",
                bankName: data.brand ?? "",
                bankImage: link.brand.imageUrl ?? .empty,
                endNumber: data.displayNumber ?? "",
                lastClosedBill: previousBill.formattedAsBRL(),
                isMainBank: link.brand.isMainInstitution?.boolValue ?? false
            )
        })
    }

    private func getImage(for brand: String?) -> UIImage {
        guard let brand, let creditCardBrand = CreditCardBrand(rawValue: brand) else { return UIImage() }

        switch creditCardBrand {
        case .visa:
            return UDSAssets.udsVisa.image
        case .mastercard:
            return UDSAssets.udsMastercard.image
        case .elo:
            return UDSAssets.udsVisa.image
        case .amex:
            return UDSAssets.udsAmex.image
        case .hipercard:
            return UDSAssets.udsVisa.image
        case .sorocred:
            return UDSAssets.udsVisa.image
        case .dinners:
            return UDSAssets.udsVisa.image
        }
    }

    private func getInsights() -> [Insight] {
        guard let spendings else { return [] }
		
        return spendings.insights.map({
            Insight(
                title: $0.title,
                description: $0.details.replacingOccurrences(of: "R$ ", with: "R$\u{00A0}"),
                iconName: getIcon(for: $0.iconName)
            )
        })
    }
    
    private func getIcon(for flag: String) -> String {
        switch flag {
        case "SPENDINGS_LEVEL_GREEN":
            return "uds-success"
        case "SPENDINGS_AVERAGE":
            return "uds-coin"
        case "CURRENT_MONTH_SPENDINGS_PERCENTAGE":
            return "uds-barchart"
        case "MOST_EXPENSIVE_MONTH":
            return "uds-chart-down"
        case "LESS_EXPENSIVE_MONTH":
            return "uds-chart-up"
        default:
            return "uds-flag"
        }
    }

    private func getSpendings() -> [MonthSpending] {
        guard let spendings else { return [] }

        return spendings.spendingsByMonth.map({
            MonthSpending(
                total: $0.amount,
                month: getMonthName(for: $0.monthIndex_),
                year: $0.year.description,
                shortMonth: getMonthName(for: $0.monthIndex_, type: .short),
                shortYear: $0.year.description.suffix(2).lowercased(),
                spendings: $0.spendingsByCategories.map({
                    SpendingCategory(
                        id: $0.category?.id ?? .empty,
                        title: $0.category?.localization?.ptBR ?? I18n.uncategorized.localized,
                        value: $0.amount.formattedAsBRL(),
                        icon: $0.category?.iconName ?? "",
                        percentage: $0.percentage_,
                        color: UIColor(hexString: $0.category?.color)
                    )
                })
            )
        })
    }

    private func getLink(id: String) -> Link? {
        links.first { $0.id == id }
    }

    private enum MonthType {
        case short
        case long
    }

    private func getMonthName(
        for index: Int32,
        type: MonthType = .long
    ) -> String {
        let monthNames = type == .short ? Calendar.ptBR.shortMonthSymbols : Calendar.ptBR.standaloneMonthSymbols
        
        return monthNames[Int(
            index
        ) - 1].capitalized.replacingOccurrences(
            of: ".",
            with: ""
        )
    }
    
    func didTapAccessAll(request: PFM.AccessAll.Request) {
        let index = request.index
        let month = spendings?.spendingsByMonth[index].monthIndex_.toInt
        let year = spendings?.spendingsByMonth[index].year.toInt
        
        guard let month, let year else { return }
        
        presenter.presentExpenses(
            response: PFM.AccessAll.Response(
                month: month,
                year: year
            )
        )
    }
    
    func didTapBringData() {
        let bottomSheetViewController = PFMRedirectViewController()

        let modalViewController = UDSBottomSheetViewController(
            viewModel: UDSBottomSheetViewModel(
                childViewController: bottomSheetViewController
            )
        )
        
        bottomSheetViewController.dismissAction = {
            modalViewController.dismiss(animated: true)
        }

        presenter.presentModal(
            response: PFM.Modal.Response(
                viewController: modalViewController
            )
        )
    }
}

extension PFMInteractor: UDSBalanceCreditCardViewModelDelegate {
    func didTapBalanceCreditCard(index: Int) {
        
        guard !creditCards.isEmpty else {
            didTapBringData()
            return
        }
        
        serviceFilter = creditCards[index]

        logger.log("Requesting presenter to present selected service")
        presenter.presentSelectedService(
            response: PFM.SelectService.Response()
        )
    }
}

extension PFMInteractor: SpendingCarroucelDelegate {
    func didSelectSpendingCard(
        at index: Int,
        categoryID: String
    ) {
        let month = spendings?.spendingsByMonth[index].monthIndex_.toInt
        let year = spendings?.spendingsByMonth[index].year.toInt
        
        guard let month, let year else { return }
        
        guard !categoryID.isEmpty else {
            presenter.presentExpenses(
                response: PFM.AccessAll.Response(
                    month: month,
                    year: year
                )
            )
            return
        }
        
        presenter.presentTransactionsByCategory(
            response: PFM.TransactionsByCategory.Response(
                month: month,
                year: year,
                categoryId: categoryID
            )
        )
    }
}

extension PFMInteractor: ChartsCarroucelDelegate {
    func didTapChart(type: DelegateChartType) {
        switch type {
        case .donut:
            presenter.presentMovements(
                response: PFM.Movements.Response(
                    month: Date().month.toInt,
                    year: Date().year.toInt
                )
            )
        case .bars(let index):
            let month = spendings?.spendingsByMonth[index].monthIndex_.toInt
            let year = spendings?.spendingsByMonth[index].year.toInt
            
            guard let month, let year else { return }
            
            presenter.presentMovements(
                response: PFM.Movements.Response(
                    month: month,
                    year: year
                )
            )
        }
    }
}
