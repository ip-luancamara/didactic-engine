//
//  PFMChangeCategoryWorker.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk

typealias GetCategoriesResult = (Result<[CategoryData], PFMChangeCategoryWorkerError>) -> Void

enum PFMChangeCategoryWorkerError: LocalizedError {
    case notFound
    case forbidden
}

protocol PFMChangeCategoryWorkerProtocol {
    func getAllCategories(completion: @escaping GetCategoriesResult)
    func changeCategory(
        transaction: Transaction_,
        to category: CategoryData,
        completion: @escaping (
            Result<
            Transaction_,
            PFMChangeCategoryWorkerError
            >
        ) -> Void
    )
}

class PFMChangeCategoryWorker: PFMChangeCategoryWorkerProtocol {

    let categoriesApi: CategoriesRestApi
    let transactionApi: TransactionsRestApi
    
    init(
        categoriesApi: CategoriesRestApi = CategoriesApi.Factory().getInstance(),
        transactionApi: TransactionsRestApi = TransactionsApi.Factory().getInstance(disableCache: false)
    ) {
        self.categoriesApi = categoriesApi
        self.transactionApi = transactionApi
    }
    
    func getAllCategories(completion: @escaping GetCategoriesResult) {
        categoriesApi.getCategories { categories, error in
            if error != nil {
                return completion(.failure(.notFound))
            }
            
            guard let categories else {
                return completion(.failure(.notFound))
            }
            
            return completion(.success(categories))
        }
    }
    
    func changeCategory(
        transaction: Transaction_,
        to category: CategoryData,
        completion: @escaping (
            Result<
            Transaction_,
            PFMChangeCategoryWorkerError
            >
        ) -> Void
    ) {
        transactionApi.changeCategory(
            linkId: transaction.linkId,
            serviceId: transaction.serviceId,
            transactionId: transaction.id,
            request: ChangeTransactionCategoryRequest(
                categoryName: category.name,
                categoryId: category.id
            )
        ) {
            transaction,
            error in
            
            guard error == nil, let transaction else {
                return completion(.failure(.notFound))
            }
            
            return completion(.success((transaction)))
        }
    }
    
}
