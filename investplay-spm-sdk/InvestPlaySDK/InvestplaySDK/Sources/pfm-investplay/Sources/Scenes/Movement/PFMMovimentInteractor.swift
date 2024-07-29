//
//  PFMMovementInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

protocol PFMMovementBusinessLogic {
    func showMovements(request: PFMMovement.ShowMovements.Request)
}

protocol PFMMovementDataStore: PFMBaseDataStore {
    var selectedTransaction: Transaction_? { get set }
}

class PFMMovementInteractor: PFMMovementBusinessLogic, PFMMovementDataStore {
    
    var links: [Link] = []
    var spendings: (any Spendings)?
    var transactions: TransactionsWithSummary?
    
    var serviceFilter: Service?
    var dateFilter: PFMDateFilter? = PFMDateFilter(month: Date().month.toInt, year: Date().year.toInt)
    var movementTypeFilter: TransactionType? = .debit
    
    let presenter: PFMMovementPresentationLogic
    var selectedTab: PFMMovementViewType = .myExpenses
    
    var selectedTransaction: Transaction_?
    
    let notificationCenter: NotificationCenter

    init(
        presenter: PFMMovementPresentationLogic,
        notificationCenter: NotificationCenter = .default
    ) {
        self.presenter = presenter
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(self, selector: #selector(didUpdateTransaction), name: .didUpdateTransaction, object: nil)
    }
    
    var transactionsPerDate: TransactionsPerDateWithIdentifier {
        let idDict: [Date: [String]] = filteredTransactions.filter(filterByIgnoredSpendings).reduce(into: [:]) {
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
    
    private func filterByIgnoredSpendings(transaction: Transaction_) -> Bool {
        guard let flag = transaction.ignoreSpending?.boolValue else { return true }
        return !flag
    }
    
    func showMovements(
        request: PFMMovement.ShowMovements.Request
    ) {
        showData(tab: .myExpenses)
    }
    
    private func reloadData() {
        showData(
            tab: selectedTab
        )
    }
    
    private func showData(tab: PFMMovementViewType) {
        guard let dateFilter else { return }
        
        switch tab {
        case .myExpenses:
            presenter.presentMovements(
                response: PFMMovement.ShowMovements.Response(
                    filterDate: dateFilter,
                    totalExpenses: filteredExpenses.map({ $0.type == .debit ? -$0.amount : $0.amount }).sum,
                    updatedAt: lastUpdate,
                    expenses: transactionsPerDate
                )
            )
        case .allTransactions:
            presenter.presentAllTransactions(
                response: PFMMovement.ShowAllTransactions.Response(
                    filterDate: dateFilter,
                    totalExits: -monthBalanceExits,
                    totalEntries: monthBalanceEntries,
                    updatedAt: lastUpdate,
                    movementTypeFilter: movementTypeFilter,
                    expenses: transactionsPerDate
                )
            )
        }
    }
}

extension PFMMovementInteractor: PFMMovementViewDelegate {
    func didTapDateChip() {
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

        presenter.presentModal(
            response: PFMMovement.ShowModal.Response(
                viewController: modalViewController
            )
        )
    }
    
    func didTapMovementTypeChip() {
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

        presenter.presentModal(
            response: PFMMovement.ShowModal.Response(
                viewController: modalViewController
            )
        )
    }
    
    func didSelect(
        tab: PFMMovementViewType
    ) {
        selectedTab = tab
        movementTypeFilter = tab == .allTransactions ? nil : .debit
        reloadData()
    }
    
    @objc func didUpdateTransaction(notification: Notification) {
        guard let newTransaction = notification.object as? Transaction_, let transactions else { return }
        
        self.transactions = TransactionsWithSummary(
            summary: transactions.summary,
            transactions: transactions.transactions.compactMap({ $0.id == newTransaction.id ? newTransaction : $0 })
        )
        
        reloadData()
    }
}

extension PFMMovementInteractor: PFMItemSelectionDelegate {
    func didSelect(
        month: Int,
        year: Int
    ) {
        dateFilter = PFMDateFilter(month: month, year: year)
        reloadData()
    }
    
    func didTapCleanFilter() {
        movementTypeFilter = nil
        reloadData()
    }
    
    func didSelect(
        item: PFMSelectionItem
    ) {
        guard item.type == .movement else { return }
        
        switch item.title {
        case I18n.entries.localized:
            movementTypeFilter = .credit
        case I18n.exits.localized:
            movementTypeFilter = .debit
        default:
            break
        }
        
        reloadData()
    }
}

extension PFMMovementInteractor: UDSSpendingViewModelDelegate {
    func didTapView(
        sender: UDSSpending
    ) {
        selectedTransaction = transactions?.transactions.first(where: { $0.id == sender.accessibilityIdentifier })
        guard selectedTransaction != nil else { return }
        presenter.presentTransactionDetails(response: PFMMovement.TransactionDetails.Response())
    }
}
