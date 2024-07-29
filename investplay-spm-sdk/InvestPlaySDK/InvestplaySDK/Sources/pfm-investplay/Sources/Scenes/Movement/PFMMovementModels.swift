//
//  PFMMovementModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem
import NetworkSdk
import UIKit

enum PFMMovement {
    enum ShowMovements {
        struct Request { }
        
        struct Response { 
            let filterDate: PFMDateFilter
            let totalExpenses: Double
            let updatedAt: Date
            let expenses: TransactionsPerDateWithIdentifier
        }
        
        struct ViewModel {
            let filterDate: String
            let totalExpenses: String
            let updatedAt: String
            let expenses: TransactionsPerDateWithIdentifier
        }
    }
    
    enum ShowAllTransactions {
        struct Request { }
        
        struct Response {
            let filterDate: PFMDateFilter
            let totalExits: Double
            let totalEntries: Double
            let updatedAt: Date
            let movementTypeFilter: TransactionType?
            let expenses: TransactionsPerDateWithIdentifier
        }
        
        struct ViewModel {
            let filterDate: String
            let totalExits: String
            let totalEntries: String
            let total: String
            let updatedAt: String
            let movementTypeFilter: I18n
            let expenses: TransactionsPerDateWithIdentifier
        }
    }
    
    enum ShowModal {
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
}
