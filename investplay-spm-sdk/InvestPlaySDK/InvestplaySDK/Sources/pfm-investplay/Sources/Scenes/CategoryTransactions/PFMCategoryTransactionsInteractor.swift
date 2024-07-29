//
//  PFMCategoryTransactionsInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

protocol PFMCategoryTransactionsBusinessLogic {
    func showMovements(request: PFMCategoryTransactions.ShowMovements.Request)
}

protocol PFMCategoryTransactionsDataStore: PFMBaseDataStore {
    var categoryFilter: String? { get set }
    var selectedTransaction: Transaction_? { get set }
}

class PFMCategoryTransactionsInteractor: PFMCategoryTransactionsBusinessLogic, PFMCategoryTransactionsDataStore {
    
    var links: [Link] = []
    var spendings: (any Spendings)?
    var transactions: TransactionsWithSummary?
    
    var serviceFilter: Service?
    var dateFilter: PFMDateFilter? = PFMDateFilter(month: Date().month.toInt, year: Date().year.toInt)
    var movementTypeFilter: TransactionType?
    
    var categoryFilter: String?
    var selectedTransaction: Transaction_?
    
    let notificationCenter: NotificationCenter
    
    var categoryName: String {
        filteredTransactions.filter({ $0.category?.id == categoryFilter }).first?.category?.name ?? "Não categorizado"
    }
    
    let presenter: PFMCategoryTransactionsPresentationLogic

    init(
        presenter: PFMCategoryTransactionsPresentationLogic,
        notificationCenter: NotificationCenter = .default
    ) {
        self.presenter = presenter
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(self, selector: #selector(didUpdateTransaction), name: .didUpdateTransaction, object: nil)
    }
    
    var transactionsPerDate: TransactionsPerDateWithIdentifier {
        guard let categoryFilter else { return [:] }
        
        let searchFilter = categoryFilter.isEmpty ? nil : categoryFilter
        
        let idDict: [Date: [String]] = filteredTransactions.filter({ $0.category?.id == searchFilter }).reduce(into: [:]) {
            let date = $1.date.toDate()
            $0[date, default: []].append($1.id)
        }
        
        return idDict.compactMapValues({ transactionsID in
            let transactions = transactionsID.compactMap { id in filteredTransactions.first(where: { $0.id == id }) }
            
            return transactions.enumerated().map({
                (
                    $1.toUDS(
                        title: getTitle(for: $1),
                        showDivider: $0 != transactions.endIndex - 1,
                        delegate: self
                    ), $1.id
                )
            })
            
        })
    }
    
    func showMovements(
        request: PFMCategoryTransactions.ShowMovements.Request
    ) {
        guard let dateFilter else { return }
        
        let expenses = transactionsPerDate.filter({ $0.key.month == dateFilter.month && $0.key.year == dateFilter.year })
        
        presenter.presentMovements(
            response: PFMCategoryTransactions.ShowMovements.Response(
                filterDate: dateFilter,
                totalExpenses: filteredTransactions.filter({ $0.category?.id == categoryFilter }).map({ $0.amount }).sum,
                expenses: transactionsPerDate.filter({ $0.key.month == dateFilter.month }),
                selectedCategory: categoryName
            )
        )
    }
    
    @objc func didUpdateTransaction(notification: Notification) {
        guard let newTransaction = notification.object as? Transaction_, let transactions else { return }
        
        self.transactions = TransactionsWithSummary(
            summary: transactions.summary,
            transactions: transactions.transactions.compactMap({ $0.id == newTransaction.id ? newTransaction : $0 })
        )
        
        showMovements(request: PFMCategoryTransactions.ShowMovements.Request())
    }
}

extension PFMCategoryTransactionsInteractor: UDSSpendingViewModelDelegate {
    func didTapView(sender: DesignSystem.UDSSpending) {
        selectedTransaction = transactions?.transactions.first(where: { $0.id == sender.accessibilityIdentifier })
        guard let selectedTransaction else { return }
        presenter.presentTransactionDetails(response: PFMCategoryTransactions.TransactionDetails.Response())
    }
}
