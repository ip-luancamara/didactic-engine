//
//  PFMServiceDetailsInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 11/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

typealias TransactionsPerDate = [Date: [UDSSpendingViewModel]]
typealias TransactionsPerDateWithIdentifier = [Date: [(UDSSpendingViewModel, String)]]

protocol PFMServiceDetailsBusinessLogic {
    func showDetails(request: PFMServiceDetails.ShowServiceDetails.Request)
    func refetchData(request: PFMServiceDetails.RefetchData.Request)
}

protocol PFMServiceDetailsDataStore: PFMBaseDataStore { 
    var selectedTransaction: Transaction_? { get }
}

class PFMServiceDetailsInteractor: PFMServiceDetailsBusinessLogic, PFMServiceDetailsDataStore {

    var links: [Link] = []
    var spendings: Spendings?
    var transactions: TransactionsWithSummary?

    var serviceFilter: Service?
    var dateFilter: PFMDateFilter?
    var movementTypeFilter: TransactionType?
    
    var selectedTransaction: Transaction_?

    let presenter: PFMServiceDetailsPresentationLogic
    let worker: PFMServiceDetailsWorker

    init(
        presenter: PFMServiceDetailsPresentationLogic,
        worker: PFMServiceDetailsWorker = PFMServiceDetailsWorker()
    ) {
        self.presenter = presenter
        self.worker = worker
    }
    
    var transactionsPerDate: TransactionsPerDateWithIdentifier {
        let idDict: [Date: [String]] = filteredTransactions.reduce(into: [:]) {
            let date = $1.date.toDate()
            $0[date, default: []].append($1.id)
        }
        
        return idDict.compactMapValues({ transactionsID in
            let transactions = transactionsID.compactMap { id in filteredTransactions.first(where: { $0.id == id }) }
            
            return transactions.enumerated().map({
                (
                    $1.toUDS(
                        title: getTitle(for: $1),
                        showDivider: transactions.endIndex == 1 ? false : $0 != transactions.endIndex - 1,
                        delegate: self
                    ), $1.id
                )
            })
            
        })
    }

    private func getTransactions(
        for month: Int32
    ) -> TransactionsPerDateWithIdentifier {
        transactionsPerDate.filter({ $0.key.month == dateFilter?.month.toInt32 && $0.key.year == dateFilter?.year.toInt32 })
    }

    // MARK: Business logic

    func showDetails(
        request: PFMServiceDetails.ShowServiceDetails.Request
    ) {
        guard
            let serviceFilter,
            let link = getLink(for: serviceFilter),
            let imageURL = link.brand.imageUrl,
            let updatedAt = link.lastUpdateAt
        else { return }
        
        dateFilter = request.dateFilter

        var response: PFMServiceDetails.ShowServiceDetails.Response?

        if serviceFilter.type == .account {
            guard
                let accountData = serviceFilter.accountData,
                let accountNumber = accountData.displayNumber
            else { return }
            
            

            response = PFMServiceDetails.ShowServiceDetails.Response(
                type: .account(Account(
                    id: serviceFilter.id,
                    bankName: link.brand.name,
                    imageURL: imageURL,
                    accountNumber: accountNumber,
                    balance: accountData.balance.formattedAsBRL()
                )),
                screenTitle: .accountDetails,
                updatedAt: updatedAt.toDate(),
                selectedMonth: request.dateFilter?.month ?? Date().month.toInt,
                selectedYear: request.dateFilter?.year ?? Date().year.toInt,
                totalEntries: monthBalanceEntries,
                totalExits: monthBalanceExits,
                balance: monthBalance,
                transactions: getTransactions(for: request.dateFilter?.month.toInt32 ?? Date().month),
                movementFilter: movementTypeFilter
            )
        }

        if serviceFilter.type == .creditCard {
            guard
                let cardData = serviceFilter.creditCardData,
                let level = cardData.level,
                let limit = cardData.availableCreditLimit,
                let link = getLink(for: serviceFilter)
            else { return }

            response = PFMServiceDetails.ShowServiceDetails.Response(
                type: .card(
                    CreditCard(
                        id: serviceFilter.id,
                        level: level.capitalized,
                        image: getImage(for: cardData.brand),
                        limit: limit.doubleValue.formattedAsBRL(),
                        currentStatement: cardData.balance.formattedAsBRL(),
                        dueDate: cardData.balanceDueDate?.toDate().toCreditCardDueDate() ?? "",
                        bankName: cardData.brand ?? "",
                        bankImage: link.brand.imageUrl ?? .empty,
                        endNumber: cardData.displayNumber ?? "",
                        lastClosedBill: cardData.previousBill?.totalAmount.formattedAsBRL() ?? "",
                        isMainBank: link.brand.isMainInstitution?.boolValue ?? false
                    )
                ),
                screenTitle: .cardDetails,
                updatedAt: updatedAt.toDate(),
                selectedMonth: request.dateFilter?.month ?? Date().month.toInt,
                selectedYear: request.dateFilter?.year ?? Date().year.toInt,
                totalEntries: monthBalanceEntries,
                totalExits: monthBalanceExits,
                balance: monthBalance,
                transactions: getTransactions(
                    for: request.dateFilter?.month.toInt32 ?? Date().month
                ),
                movementFilter: movementTypeFilter
            )
        }

        guard let response else { return }

        presenter.presentDetails(response: response)
    }
    
    func refetchData(request: PFMServiceDetails.RefetchData.Request) {
        worker.refetchTransactions { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                self.showDetails(
                    request: PFMServiceDetails.ShowServiceDetails.Request(
                        dateFilter: dateFilter
                    )
                )
            case .failure(let error):
                // TODO: Implement Error Handling
                print(error)
            }
        }
    }

    private func getImage(for brand: String?) -> UIImage {
        return ImageAsset.getAsset(by: "uds-visa").image

        // TODO: Implement when UDS updates
        switch brand {
        case "MASTERCARD":
            return ImageAsset.getAsset(by: "uds-mastercard").image
        case "VISA":
            return UDSAssets.udsVisa.image
        default:
            return UIImage()
        }
    }

    private func getCreditCards() -> [CreditCard] {
        creditCards.compactMap { card in
            guard let data = card.creditCardData, let serviceFilter, let link = getLink(for: serviceFilter) else { return nil }
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
        }
    }
}

extension PFMServiceDetailsInteractor: PFMItemSelectionDelegate {
    func didSelect(month: Int, year: Int) {
        showDetails(
            request: PFMServiceDetails.ShowServiceDetails.Request(
                dateFilter: PFMDateFilter(
                    month: month,
                    year: year
                )
            )
        )
    }
    
    func didSelect(item: PFMSelectionItem) {
        switch item.type {
        case .date:
            break
        case .movement:
            switch item.title {
                case I18n.entries.localized:
                    movementTypeFilter = .credit
                case I18n.exits.localized:
                    movementTypeFilter = .debit
            default:
                break
            }
        case .service:
            serviceFilter = services.first { $0.id == item.id }
        }
        
        showDetails(
            request: PFMServiceDetails.ShowServiceDetails.Request(
                dateFilter: dateFilter
            )
        )
    }
    
    func didTapCleanFilter() {
        movementTypeFilter = nil
        showDetails(
            request: PFMServiceDetails.ShowServiceDetails.Request(
                dateFilter: dateFilter
            )
        )
    }
}

extension PFMServiceDetailsInteractor: PFMServiceDetailsDelegate {
    func didTapServiceChip(selectedID: String) {
        guard let serviceFilter else { return }
        
        let type: PFMItemType = serviceFilter.type == .account ? .accounts(
            accounts.compactMap({
                guard
                    let link = getLink(
                        for: $0
                    ),
                    let accountNumber = $0.accountData?.displayNumber,
                    let imageURL = link.brand.imageUrl
                else {
                    return nil
                }

                return AccountBase(
                    id: $0.id,
                    bankName: link.brand.name,
                    imageURL: imageURL,
                    accountNumber: accountNumber
                )
            })
        ) : .cards(
            getCreditCards()
        )
        
        let selectedIndex = type.getIndexOfID(selectedID: selectedID)
        guard let selectedIndex else { return }
        
        let bottomSheetViewController = PFMItemSelectionViewController(
            type: type, selectedIndex: selectedIndex
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

        presenter.presentSelectModal(
            response: PFMServiceDetails.ServiceModal.Response(
                viewController: modalViewController
            )
        )
    }

    func didTapDateChip(selectedMonth: Int, selectedYear: Int) {
        let bottomSheetViewController = PFMItemSelectionViewController(
            type: .date,
            selectedYear: selectedYear,
            selectedMonth: selectedMonth
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

        presenter.presentSelectModal(
            response: PFMServiceDetails.ServiceModal.Response(
                viewController: modalViewController
            )
        )
    }
    
    func didTapMovementTypeChip(selected: PFMMovementType?) {
        let selectedIndex: Int?
        
        switch movementTypeFilter {
        case .none:
            selectedIndex = nil
        default:
            selectedIndex = movementTypeFilter == .credit ? 0 : 1
        }
        
        let bottomSheetViewController = PFMItemSelectionViewController(type: .transaction, selectedIndex: selectedIndex)
        
        bottomSheetViewController.delegate = self

        let modalViewController = UDSBottomSheetViewController(
            viewModel: UDSBottomSheetViewModel(
                childViewController: bottomSheetViewController
            )
        )

        bottomSheetViewController.dismiss = {
            modalViewController.dismiss(animated: true)
        }

        presenter.presentSelectModal(
            response: PFMServiceDetails.ServiceModal.Response(
                viewController: modalViewController
            )
        )
    }
}

extension PFMServiceDetailsInteractor: UDSSpendingViewModelDelegate {
    func didTapView(sender: DesignSystem.UDSSpending) {
        selectedTransaction = transactions?.transactions.first(where: { $0.id == sender.accessibilityIdentifier })
        guard let selectedTransaction else { return }
        presenter.presentTransactionDetails(response: PFMServiceDetails.TransactionDetails.Response())
    }
}
