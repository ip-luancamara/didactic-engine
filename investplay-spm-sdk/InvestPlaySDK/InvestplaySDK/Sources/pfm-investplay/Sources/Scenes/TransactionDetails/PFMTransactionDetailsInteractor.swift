//
//  PFMTransactionDetailsInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

protocol PFMTransactionDetailsBusinessLogic {
    func fetchTransactionDetails(request: PFMTransactionDetails.TransactionDetails.Request)
    func changeIgnoreSpendingFlag(request: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Request)
}

protocol PFMTransactionDetailsDataStore: PFMBaseDataStore {
    var selectedTransaction: Transaction_? { get set }
}

class PFMTransactionDetailsInteractor: PFMTransactionDetailsBusinessLogic, PFMTransactionDetailsDataStore {
    
    var selectedTransaction: Transaction_?
    
    var links: [Link] = []
    var spendings: Spendings?
    var transactions: TransactionsWithSummary?

    var serviceFilter: Service?
    var dateFilter: PFMDateFilter?
    var movementTypeFilter: TransactionType?
    
    var presenter: PFMTransactionDetailsPresentationLogic?
    var worker: PFMTransactionDetailsWorker?
    
    let notificationCenter: NotificationCenter
    
    init(
        worker: PFMTransactionDetailsWorker = PFMTransactionDetailsWorker(),
        notificationCenter: NotificationCenter = .default
    ) {
        self.worker = worker
        self.notificationCenter = notificationCenter
    }
    
    func fetchTransactionDetails(request: PFMTransactionDetails.TransactionDetails.Request) {
        guard let selectedTransaction else { return }
        
        let link = getLink(for: selectedTransaction)
        
        guard let link else { return }
        
        let response = PFMTransactionDetails.TransactionDetails.Response(
            type: getTransactionType(from: selectedTransaction),
            title: selectedTransaction.description_,
            value: selectedTransaction.amount,
            date: selectedTransaction.date.toDate(),
            fromTitle: link.brand.name,
            fromSubtitle: getSubtitle(for: selectedTransaction),
            fromImageURL: link.brand.imageUrl ?? .empty,
            category: getViewModel(for: selectedTransaction.category),
            isIgnored: selectedTransaction.ignoreSpending?.boolValue ?? false
        )
        
        presenter?.presentTransactionDetails(response: response)
    }
    
    func changeIgnoreSpendingFlag(
        request: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Request
    ) {
        guard let selectedTransaction else { return }
        
        worker?.changeIgnoreSpendingFlag(
            transaction: selectedTransaction,
            shouldIgnore: request.shouldIgnore
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let transaction):
                self.selectedTransaction = transaction
                notificationCenter.post(name: .didUpdateTransaction, object: transaction)
                presenter?.presentIgnoredSpending(response: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Response(success: true))
            case .failure(let error):
                presenter?.presentIgnoredSpending(response: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Response(success: false))
                print(error)
            }
        }
    }
    
    func getTransactionType(from transaction: Transaction_) -> PFMTransactionDetailsType {
        switch transaction.type {
        case .credit:
            return .entry
        case .debit:
            return .exit
        default:
            return .exit
        }
    }
    
    func getService(for transaction: Transaction_) -> Service? {
        services.first { $0.id == transaction.serviceId }
    }
    
    func getSubtitle(for transaction: Transaction_) -> String {
        guard
            let selectedTransaction,
            let service = getService(for: selectedTransaction),
            let link = getLink(for: selectedTransaction)
        else { return .empty }
        
        switch service.type {
        case .account:
            guard let accountNumber = service.accountData?.displayNumber else { return .empty }
            return "\(link.brand.name) • \(accountNumber)"
        case .creditCard:
            guard
                let cardNumber = service.creditCardData?.displayNumber,
                let level = service.creditCardData?.level,
                let flag = service.creditCardData?.brand
            else { return .empty }
            return "\(flag) \(level) • \(cardNumber)"
        default:
            return .empty
        }
        
    }
    
    func getViewModel(for category: CategoryData?) -> UDSSpendingActionViewModel {
        guard let category else {
            return UDSSpendingActionViewModel(
                title: "Não categorizado",
                subtitle: I18n.category.localized,
                icon: ImageAsset.getAsset(by: "uds-flag").image,
                showDivider: true,
                indicatorColor: UDSColors.grey500.color,
                tag: UDSTagModel(title: I18n.change.localized, style: .neutral(highPriority: false)),
                delegate: self
            )
        }
        
        return UDSSpendingActionViewModel(
            title: category.name,
            subtitle: I18n.category.localized,
            icon: ImageAsset.getAsset(by: category.iconName ?? .empty).image,
            showDivider: true,
            indicatorColor: UIColor(hexString: category.color),
            tag: UDSTagModel(title: I18n.change.localized, style: .neutral(highPriority: false)),
            delegate: self
        )
    }
}

extension PFMTransactionDetailsInteractor: UDSSpendingActionViewModelDelegate {
    func didTapView(
        sender: UDSSpendingAction
    ) {
        presenter?.presentChangeCategory(
            response: PFMTransactionDetails.ChangeCategory.Response(delegate: self)
        )
    }
}

extension PFMTransactionDetailsInteractor: PFMChangeCategoryDelegate {
    func didChangeCategory(
        newTransaction: Transaction_
    ) {
        selectedTransaction = newTransaction
        
        fetchTransactionDetails(request: PFMTransactionDetails.TransactionDetails.Request())
    }
}
