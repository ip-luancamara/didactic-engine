//
//  LinksRestApiSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import NetworkSdk

class LinksRestApiSpy: LinksRestApi {
    var wasGetLinkCalled = false
    var wasGetLinksCalled = false

    var getLinkCompletionHandler: (
        (
            _ linkId: String,
            _ completionHandler: @escaping (
                Link?,
                (
                    Error
                )?
            ) -> Void
        ) -> Void
    )?
    var getLinksCompletionHandler: (
        (
            _ loadServices: Bool,
            _ completionHandler: @escaping (
                [Link]?,
                (
                    Error
                )?
            ) -> Void
        ) -> Void
    )?

    func getLink(
        linkId: String,
        completionHandler: @escaping (
            Link?,
            (
                Error
            )?
        ) -> Void
    ) {
        wasGetLinkCalled = true
        getLinkCompletionHandler?(
            linkId,
            completionHandler
        )
    }

    func getLink(
        linkId: String
    ) async throws -> Link {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetLinkCalled = true

            guard let getLinkCompletionHandler else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            getLinkCompletionHandler(
                linkId
            ) { (link, error) in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let link {
                    continuation.resume(returning: link)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }

    func getLinks(
        loadServices: Bool,
        completionHandler: @escaping (
            [Link]?,
            (
                Error
            )?
        ) -> Void
    ) {
        wasGetLinksCalled = true
        getLinksCompletionHandler?(
            loadServices,
            completionHandler
        )
    }

    func getLinks(
        loadServices: Bool
    ) async throws -> [Link] {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            wasGetLinksCalled = true

            guard let getLinksCompletionHandler else {
                continuation.resume(throwing: TestError.noResponseProvided)
                return
            }

            getLinksCompletionHandler(
                loadServices
            ) { (links, error) in
                if let error {
                    continuation.resume(throwing: TestError.kmpError(error))
                } else if let links {
                    continuation.resume(returning: links)
                } else {
                    continuation.resume(throwing: TestError.noResponseProvided)
                }
            }
        }
    }
}
