//
//  TransactionsRestApiSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk

class TransactionsRestApiSpy: TransactionsRestApi {
    
    var wasChangeCategoryCalled = false
    var wasChangeIgnoreSpendingFlagCalled = false
    var wasGetTransactionCalled = false
    var wasGetTransactionsWithSummaryCalled = false

    var changeCategoryCompletionHandler: (
        (
            _ linkId: String,
            _ serviceId: String,
            _ transactionId: String,
            _ request: ChangeTransactionCategoryRequest,
            _ completionHandler: @escaping (
                Transaction_?,
                Error?
            ) -> Void
        ) -> Void
    )?
    var changeIgnoreSpendingFlagCompletionHandler: (
        (
            _ linkId: String,
            _ serviceId: String,
            _ transactionId: String,
            _ request: ChangeTransactionIgnoreSpendingRequest,
            _ completionHandler: @escaping (
                Transaction_?,
                Error?
            ) -> Void
        ) -> Void
    )?
    var getTransactionCompletionHandler: (
        (
            _ linkId: String,
            _ serviceId: String,
            _ transactionId: String,
            _ completionHandler: @escaping (
                Transaction_?,
                Error?
            ) -> Void
        ) -> Void
    )?
    var getTransactionsWithSummaryCompletionHandler: (
        (
            _ from: Kotlinx_datetimeLocalDate,
            _ to: Kotlinx_datetimeLocalDate,
            _ completionHandler: @escaping (
                TransactionsWithSummary?,
                Error?
            ) -> Void
        ) -> Void
    )?
    func changeCategory(
        linkId: String,
        serviceId: String,
        transactionId: String,
        request: ChangeTransactionCategoryRequest,
        completionHandler: @escaping (
            Transaction_?,
            Error?
        ) -> Void
    ) {
        wasChangeCategoryCalled = true
        changeCategoryCompletionHandler?(
            linkId,
            serviceId,
            transactionId,
            request,
            completionHandler
        )
    }

    func changeCategory(
        linkId: String,
        serviceId: String,
        transactionId: String,
        request: ChangeTransactionCategoryRequest
    ) async throws -> Transaction_ {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasChangeCategoryCalled = true

            self.changeCategoryCompletionHandler?(
                linkId,
                serviceId,
                transactionId,
                request
            ) { transaction, error in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let transaction {
                    continuation.resume(returning: transaction)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }

    func changeIgnoreSpendingFlag(
        linkId: String,
        serviceId: String,
        transactionId: String,
        request: ChangeTransactionIgnoreSpendingRequest,
        completionHandler: @escaping (
            Transaction_?,
            Error?
        ) -> Void
    ) {
        wasChangeIgnoreSpendingFlagCalled = true
        changeIgnoreSpendingFlagCompletionHandler?(
            linkId,
            serviceId,
            transactionId,
            request,
            completionHandler
        )
    }

    func changeIgnoreSpendingFlag(
        linkId: String,
        serviceId: String,
        transactionId: String,
        request: ChangeTransactionIgnoreSpendingRequest
    ) async throws -> Transaction_ {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasChangeIgnoreSpendingFlagCalled = true

            self.changeIgnoreSpendingFlagCompletionHandler?(
                linkId,
                serviceId,
                transactionId,
                request
            ) { transaction, error in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let transaction {
                    continuation.resume(returning: transaction)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }

    func getTransaction(
        linkId: String,
        serviceId: String,
        transactionId: String,
        completionHandler: @escaping (
            Transaction_?,
            Error?
        ) -> Void
    ) {
        wasGetTransactionCalled = true
        getTransactionCompletionHandler?(
            linkId,
            serviceId,
            transactionId,
            completionHandler
        )
    }

    func getTransaction(
        linkId: String,
        serviceId: String,
        transactionId: String
    ) async throws -> Transaction_ {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetTransactionCalled = true

            self.getTransactionCompletionHandler?(
                linkId,
                serviceId,
                transactionId
            ) { transaction, error in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let transaction {
                    continuation.resume(returning: transaction)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }

    func getTransactionsWithSummary(
        from: Kotlinx_datetimeLocalDate,
        to: Kotlinx_datetimeLocalDate,
        linkId: String?,
        serviceId: String?,
        completionHandler: @escaping (
            TransactionsWithSummary?,
            Error?
        ) -> Void
    ) {
        wasGetTransactionsWithSummaryCalled = true
        getTransactionsWithSummaryCompletionHandler?(
            from,
            to,
            completionHandler
        )
    }

    func getTransactionsWithSummary(
        from: Kotlinx_datetimeLocalDate,
        to: Kotlinx_datetimeLocalDate,
        linkId: String?,
        serviceId: String?
    ) async throws -> TransactionsWithSummary {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetTransactionsWithSummaryCalled = true

            self.getTransactionsWithSummaryCompletionHandler?(
                from,
                to
            ) { transactionsWithSummary, error in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let transactionsWithSummary {
                    continuation.resume(returning: transactionsWithSummary)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }
}
