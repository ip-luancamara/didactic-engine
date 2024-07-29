//
//  PFMChangeCategoryInteractor.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

protocol PFMChangeCategoryBusinessLogic {
    var delegate: PFMChangeCategoryDelegate? { get set }
    func getCategories(request: PFMChangeCategory.GetCategories.Request)
}

protocol PFMChangeCategoryDataStore {
    var selectedTransaction: Transaction_? { get set }
}

protocol PFMChangeCategoryDelegate: AnyObject {
    func didChangeCategory(newTransaction: Transaction_)
}

class PFMChangeCategoryInteractor: PFMChangeCategoryBusinessLogic, PFMChangeCategoryDataStore {
    
    var selectedTransaction: Transaction_?
    
    weak var delegate: PFMChangeCategoryDelegate?
    
    var presenter: PFMChangeCategoryPresentationLogic?
    var worker: PFMChangeCategoryWorkerProtocol?
    
    var categories: [CategoryData] = []
    
    let notificationCenter: NotificationCenter
    
    init(
        worker: PFMChangeCategoryWorkerProtocol = PFMChangeCategoryWorker(),
        notificationCenter: NotificationCenter = .default
    ) {
        self.worker = worker
        self.notificationCenter = notificationCenter
    }
    
    func getCategories(
        request: PFMChangeCategory.GetCategories.Request
    ) {
        worker?.getAllCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                self.presenter?.presentCategories(
                    response: PFMChangeCategory.GetCategories.Response(
                        categories: categories,
                        selectedCategoryId: selectedTransaction?.category?.id ?? .empty,
                        selectedCategoryName: selectedTransaction?.category?.name ?? .empty,
                        delegate: self
                    )
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

extension PFMChangeCategoryInteractor: UDSSpendingActionViewModelDelegate {
    func didTapView(
        sender: UDSSpendingAction
    ) {
        let category = categories.first { $0.id == sender.accessibilityIdentifier }
        guard let category, let selectedTransaction else { return }
        
        presenter?.presentLoading(response: PFMChangeCategory.Loading.Response())
        
        worker?.changeCategory(
            transaction: selectedTransaction,
            to: category
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let transaction):
                self.selectedTransaction = transaction
                notificationCenter.post(name: .didUpdateTransaction, object: transaction)
                delegate?.didChangeCategory(newTransaction: transaction)
                presenter?.presentChangeCategory(response: PFMChangeCategory.ChangeCategory.Response(success: true))
            case .failure:
                presenter?.presentChangeCategory(response: PFMChangeCategory.ChangeCategory.Response(success: false))
            }
        }
    }
}
