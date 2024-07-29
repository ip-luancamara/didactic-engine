//
//  PFMServiceDetailsWorker.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 30/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
import NetworkSdk

class PFMServiceDetailsWorker {
    
    let transactionsAPI: TransactionsRestApi
    
    init(
        transactionsAPI: TransactionsRestApi = TransactionsApi.Factory().getInstance(disableCache: false)
    ) {
        self.transactionsAPI = transactionsAPI
    }
    
    func refetchTransactions(
        completion: @escaping (Result<TransactionsWithSummary, PFMWorkerError>) -> Void
    ) {
        transactionsAPI.getTransactionsWithSummary(
            from: .threeMonthAgo,
            to: .now,
            linkId: nil,
            serviceId: nil
        ) { transactions, error in
            if let error {
                return completion(.failure(.notFound))
            }
            guard let transactions else { return completion(.failure(.notFound)) }
            return completion(.success(transactions))
        }
    }
    
}
