//
//  PFMServiceDetailsModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 11/04/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk
@_implementationOnly import DesignSystem
import UIKit

enum PFMServiceDetails {

    enum SelectAccount {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }

    enum ShowServiceDetails {

        struct Request {
            let dateFilter: PFMDateFilter?
        }

        struct Response {
            let type: PFMServiceType
            let screenTitle: I18n
            let updatedAt: Date
            let selectedMonth: Int
            let selectedYear: Int
            let totalEntries: Double
            let totalExits: Double
            let balance: Double
            let transactions: TransactionsPerDateWithIdentifier
            let movementFilter: TransactionType?
        }

        struct ViewModel {
            let type: PFMServiceType
            let screenTitle: String
            let month: Int
            let year: Int
            let transactions: TransactionsPerDateWithIdentifier
            let totalEntries: String
            let totalExits: String
            let balance: String
            let updatedAt: String
            let movementFilterTitle: I18n
        }
    }

    enum ServiceModal {
        struct Request { }

        struct Response {
            let viewController: UIViewController
        }

        struct ViewModel {
            let viewController: UIViewController
        }
    }
    
    enum TransactionDetails {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum RefetchData {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }

}

struct Transaction {
    let icon: String
    let title: String
    let description: String
    let value: Double
}

enum PFMServiceType: Equatable {
    case account(Account)
    case card(CreditCard)

    var isCard: Bool {
        switch self {
        case .account:
            return false
        case .card:
            return true
        }
    }
}
