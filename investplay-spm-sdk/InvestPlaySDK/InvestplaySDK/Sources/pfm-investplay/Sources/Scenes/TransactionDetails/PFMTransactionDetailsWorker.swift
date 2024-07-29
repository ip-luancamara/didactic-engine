//
//  PFMTransactionDetailsWorker.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk

typealias ChangeIgnoreFlagResult = (Result<Transaction_, PFMTransactionDetailsWorkerError>) -> Void

enum PFMTransactionDetailsWorkerError: LocalizedError {
    case notFound
    case forbidden
}

class PFMTransactionDetailsWorker {
    
    let transactionApi: TransactionsRestApi
    
    init(
        transactionApi: TransactionsRestApi = TransactionsApi.Factory().getInstance(disableCache: false)
    ) {
        self.transactionApi = transactionApi
    }
    
    func changeIgnoreSpendingFlag(
        transaction: Transaction_,
        shouldIgnore: Bool,
        completionHandler: @escaping ChangeIgnoreFlagResult
    ) {
        transactionApi.changeIgnoreSpendingFlag(
            linkId: transaction.linkId,
            serviceId: transaction.serviceId,
            transactionId: transaction.id,
            request: ChangeTransactionIgnoreSpendingRequest(ignoreSpending: shouldIgnore)
        ) {
            transaction,
            error in
            
            if error != nil {
                return completionHandler(.failure(.notFound))
            }
            
            if let transaction {
                return completionHandler(.success(transaction))
            }
            
            return completionHandler(.failure(.notFound))
        }
    }
    
}
