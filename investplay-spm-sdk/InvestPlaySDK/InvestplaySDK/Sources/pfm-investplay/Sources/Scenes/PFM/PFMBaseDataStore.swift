//
//  PFMBaseDataStore.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 06/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

struct PFMDateFilter: Equatable {
    let month: Int
    let year: Int
    
    static var current: PFMDateFilter {
        PFMDateFilter(month: Date().month.toInt, year: Date().year.toInt)
    }
}

protocol PFMBaseDataStore {
    var links: [Link] { get set }
    var spendings: Spendings? { get set }
    var transactions: TransactionsWithSummary? { get set }
    
    var serviceFilter: Service? { get set }
    var dateFilter: PFMDateFilter? { get set }
    var movementTypeFilter: TransactionType? { get set }
}

extension PFMBaseDataStore {
    var services: [Service] {
        links
            .compactMap({ $0.services })
            .reduce([], +)
            .sorted(by: { $0.belongsToMainInstitution != $1.belongsToMainInstitution })
    }
    
    var filteredTransactions: [Transaction_] {
        guard let transactions else { return [] }
        
        return transactions.transactions
            .filter(filterByService)
            .filter(filterByDate)
            .filter(filterByMovementType)
    }
    
    var filteredExpenses: [Transaction_] {
        filteredTransactions.filter(filterByIgnoredSpendings)
    }
    
    var lastUpdate: Date {
        guard let serviceFilter, let link = getLink(for: serviceFilter), let lastUpdate = link.lastUpdateAt else { return Date() }
        return lastUpdate.toDate()
    }
    
    var monthBalanceEntries: Double {
        guard let transactions else { return 0 }
        
        return transactions.transactions
            .filter(filterByDate)
            .filter(filterByService)
            .filter({ $0.type == .credit })
            .map({ $0.amount })
            .sum
    }
    
    var monthBalanceExits: Double {
        guard let transactions else { return 0 }
        
        return transactions.transactions
            .filter(filterByDate)
            .filter(filterByService)
            .filter({ $0.type == .debit })
            .map({ $0.amount })
            .sum
    }
    
    var monthBalance: Double {
        monthBalanceEntries - monthBalanceExits
    }

    var creditCards: [Service] {
        services.filter({ $0.type == .creditCard })
    }

    var creditCardsBalance: Double {
        creditCards.compactMap({ $0.creditCardData?.balance }).sum
    }

    var accounts: [Service] {
        services.filter({ $0.type == .account })
    }
    
    var accountsBalance: Double {
        accounts.compactMap({ $0.accountData?.balance }).sum
    }
    
    func getLink(for service: Service) -> Link? {
        links.first { $0.id == service.linkId }
    }

    func getLink(for transaction: Transaction_) -> Link? {
        links.first { $0.id == transaction.linkId }
    }
    
    func getService(for transaction: Transaction_) -> Service? {
        services.first { $0.id == transaction.serviceId }
    }
    
    func getTitle(for transaction: Transaction_) -> String {
        guard let link = getLink(for: transaction), let service = getService(for: transaction) else {
            return .empty
        }
	
        switch service.type {
        case .account:
            guard let accountNumber = service.accountData?.displayNumber else { return .empty }
            return "\(link.brand.name) • \(accountNumber)"
        case .creditCard:
            guard let cardNumber = service.creditCardData?.displayNumber else { return .empty }
            return "\(link.brand.name) • \(cardNumber)"
        default:
            return .empty
        }
    }
    
    private func filterByService(service: Service) -> Bool {
        guard let serviceFilter else { return true }
        return serviceFilter.id == service.id
    }
    
    private func filterByDate(transaction: Transaction_) -> Bool {
        guard let dateFilter else { return true }
        let date = transaction.date.toDate()
        return date.month == dateFilter.month && date.year == dateFilter.year
    }
    
    private func filterByMovementType(transaction: Transaction_) -> Bool {
        guard let movementTypeFilter else { return true }
        return transaction.type == movementTypeFilter
    }
    
    private func filterByService(transaction: Transaction_) -> Bool {
        guard let serviceFilter else { return true }
        return serviceFilter.id == transaction.serviceId
    }
    
    private func filterByIgnoredSpendings(transaction: Transaction_) -> Bool {
        guard let flag = transaction.ignoreSpending?.boolValue else { return true }
        return !flag
    }
}
