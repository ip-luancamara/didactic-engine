//
//  PFMWorkerSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class PFMWorkerSpy: PFMWorkerProtocol {
    var wasGetLinksCalled = false
    var wasGetServicesCalled = false
    var wasGetSpendingsCalled = false
    var wasGetTransactionsCalled = false

    var getLinksCompletionHandler: ((_ completion: @escaping GetLinksResult) -> Void)?
    var getServicesCompletionHandler: ((_ link: String, @escaping GetServicesResult) -> Void)?
    var getSpendingsCompletionHandler: ((_ completion: @escaping GetSpendingsResult) -> Void)?
    var getTransactionsCompletionHandler: ((_ completion: @escaping GetTransactionsResult) -> Void)?

    func getLinks(completion: @escaping GetLinksResult) {
        wasGetLinksCalled = true
        getLinksCompletionHandler?(completion)
    }

    func getServices(for link: String, completion: @escaping GetServicesResult) {
        wasGetServicesCalled = true
        getServicesCompletionHandler?(link, completion)
    }

    func getSpendings(completion: @escaping GetSpendingsResult) {
        wasGetSpendingsCalled = true
        getSpendingsCompletionHandler?(completion)
    }

    func getTransactions(completion: @escaping GetTransactionsResult) {
        wasGetTransactionsCalled = true
        getTransactionsCompletionHandler?(completion)
    }
}
