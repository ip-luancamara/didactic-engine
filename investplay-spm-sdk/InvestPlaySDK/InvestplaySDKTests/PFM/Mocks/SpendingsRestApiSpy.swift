//
//  SpendingsRestApiSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk

class SpendingsRestApiSpy: SpendingsRestApi {
    var wasGetSpendingsCalled = false

    var getSpendingsCompletionHandler: (
        (
            _ from: Kotlinx_datetimeLocalDate,
            _ to: Kotlinx_datetimeLocalDate,
            _ completionHandler: @escaping (
                Spendings?,
                (
                    Error
                )?
            ) -> Void
        ) -> Void
    )?

    func getSpendings(
        from: Kotlinx_datetimeLocalDate,
        to: Kotlinx_datetimeLocalDate,
        completionHandler: @escaping (
            Spendings?,
            Error?
        ) -> Void
    ) {
        wasGetSpendingsCalled = true
        getSpendingsCompletionHandler?(
            from,
            to,
            completionHandler
        )
    }

    func getSpendings(
        from: Kotlinx_datetimeLocalDate,
        to: Kotlinx_datetimeLocalDate
    ) async throws -> Spendings {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetSpendingsCalled = true

            getSpendingsCompletionHandler?(
                from,
                to
            ) { spendings, error in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let spendings = spendings {
                    continuation.resume(returning: spendings)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }
}
