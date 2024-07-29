//
//  PFMWorker.swift
//
//
//  Created by Luan Câmara on 19/03/24.
//

import Foundation
import NetworkSdk

typealias GetLinksResult = (Result<[Link], PFMWorkerError>) -> Void
typealias GetServicesResult = (Result<[Service], PFMWorkerError>) -> Void
typealias GetTransactionsResult = (Result<TransactionsWithSummary, PFMWorkerError>) -> Void
typealias GetSpendingsResult = (Result<Spendings, PFMWorkerError>) -> Void

protocol PFMWorkerProtocol {
    func getLinks(completion: @escaping GetLinksResult)
    func getServices(for link: String, completion: @escaping GetServicesResult)
    func getSpendings(completion: @escaping GetSpendingsResult)
    func getTransactions(completion: @escaping GetTransactionsResult)
}

enum PFMWorkerError: LocalizedError {
    case notFound
    case forbidden
}

final class PFMWorker: PFMWorkerProtocol {

    private let linksAPI: LinksRestApi
    private let servicesAPI: ServicesRestApi
    private let transactionsAPI: TransactionsRestApi
    private let spendingsAPI: SpendingsRestApi
    private let logger: PFMLoggerProtocol

    init(
        linksAPI: LinksRestApi = LinksApi.Factory().getInstance(),
        servicesAPI: ServicesRestApi = ServicesApi.Factory().getInstance(),
        transactionsAPI: TransactionsRestApi = TransactionsApi.Factory().getInstance(disableCache: false),
        spendingsAPI: SpendingsRestApi = SpendingsApi.Factory().getInstance(),
        logger: PFMLoggerProtocol = PFMLogger(className: PFMWorker.self)
    ) {
        self.linksAPI = linksAPI
        self.servicesAPI = servicesAPI
        self.transactionsAPI = transactionsAPI
        self.spendingsAPI = spendingsAPI
        self.logger = logger
    }

    func getLinks(
        completion: @escaping GetLinksResult
    ) {
        logger.log("Calling Get Links")
        linksAPI.getLinks(
            loadServices: true
        ) { links, error in
            
            if let error {
                self.logger.log("Error on getLinks: \(error)")
            }
            
            guard let links else { return completion(.failure(.notFound)) }
            return completion(.success(links))
        }
    }

    func getServices(
        for link: String,
        completion: @escaping GetServicesResult
    ) {
        logger.log("Calling Get Services")
        servicesAPI.getServices(
            linkId: link
        ) { services, error in
            if let error {
                self.logger.log("Error on getServices: \(error)")
            }
            guard let services else { return completion(.failure(.notFound)) }
            return completion(.success(services))
        }
    }

    func getSpendings(
        completion: @escaping GetSpendingsResult
    ) {
        logger.log("Calling Get Spendings")
        spendingsAPI.getSpendings(
            from: .twoMonthAgo,
            to: .now
        ) {
            spendings,
            error in
            if let error {
                self.logger.log("Error on getSpendings: \(error)")
            }
            guard let spendings else { return completion(.failure(.notFound)) }
            return completion(.success(spendings))
        }
    }

    func getTransactions(
        completion: @escaping GetTransactionsResult
    ) {
        logger.log("alling Get Transactions")
        transactionsAPI.getTransactionsWithSummary(
            from: .threeMonthAgo,
            to: .now,
            linkId: nil,
            serviceId: nil
        ) { transactions, error in
            if let error {
                self.logger.log("Error on getTransactions: \(error)")
            }
            guard let transactions else { return completion(.failure(.notFound)) }
            return completion(.success(transactions))
        }
    }

}
