//
//  ServicesRestApiSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk

class ServicesRestApiSpy: ServicesRestApi {
    var wasChangeServiceStatusCalled = false
    var wasGetServiceCalled = false
    var wasGetServicesCalled = false

    var changeServiceStatusCompletionHandler: (
        (
            _ linkId: String,
            _ serviceId: String,
            _ changeServiceStatusRequest: ChangeServiceStatusRequest,
            _ completionHandler: @escaping (
                Service?,
                Error?
            ) -> Void
        ) -> Void
    )?
    var getServiceCompletionHandler: (
        (
            _ linkId: String,
            _ serviceId: String,
            _ completionHandler: @escaping (
                Service?,
                Error?
            ) -> Void
        ) -> Void
    )?
    var getServicesCompletionHandler: (
        (
            _ linkId: String,
            _ completionHandler: @escaping (
                [Service]?,
                Error?
            ) -> Void
        ) -> Void
    )?

    func changeServiceStatus(
        linkId: String,
        serviceId: String,
        changeServiceStatusRequest: ChangeServiceStatusRequest,
        completionHandler: @escaping (
            Service?,
            Error?
        ) -> Void
    ) {
        wasChangeServiceStatusCalled = true
        changeServiceStatusCompletionHandler?(
            linkId,
            serviceId,
            changeServiceStatusRequest,
            completionHandler
        )
    }

    func changeServiceStatus(
        linkId: String,
        serviceId: String,
        changeServiceStatusRequest: ChangeServiceStatusRequest
    ) async throws -> Service {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasChangeServiceStatusCalled = true

            changeServiceStatusCompletionHandler?(
                linkId,
                serviceId,
                changeServiceStatusRequest, { service, error in
                    if let error {
                        continuation.resume(throwing: TestError.kmpError(error))
                    } else if let service {
                        continuation.resume(returning: service)
                    } else {
                        continuation.resume(throwing: TestError.noResponseProvided)
                    }
                }
            )
        }
    }

    func getService(
        linkId: String,
        serviceId: String,
        completionHandler: @escaping (
            Service?,
            Error?
        ) -> Void
    ) {
        wasGetServiceCalled = true
        getServiceCompletionHandler?(
            linkId,
            serviceId,
            completionHandler
        )
    }

    func getService(
        linkId: String,
        serviceId: String
    ) async throws -> Service {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetServiceCalled = true

            getServiceCompletionHandler?(
                linkId,
                serviceId, { service, error in
                    if let error {
                        continuation.resume(throwing: TestError.kmpError(error))
                    } else if let service {
                        continuation.resume(returning: service)
                    } else {
                        continuation.resume(throwing: TestError.noResponseProvided)
                    }
                }
            )
        }
    }

    func getServices(
        linkId: String,
        completionHandler: @escaping (
            [Service]?,
            Error?
        ) -> Void
    ) {
        wasGetServicesCalled = true
        getServicesCompletionHandler?(
            linkId,
            completionHandler
        )
    }

    func getServices(
        linkId: String
    ) async throws -> [Service] {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetServicesCalled = true

            getServicesCompletionHandler?(
                linkId, { services, error in
                    if let error {
                        continuation.resume(throwing: TestError.kmpError(error))
                    } else if let services {
                        continuation.resume(returning: services)
                    } else {
                        continuation.resume(throwing: TestError.noResponseProvided)
                    }
                }
            )
        }
    }
}
