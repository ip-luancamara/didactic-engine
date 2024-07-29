//
//  PFMCategoryTransactionsModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 02/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

enum PFMCategoryTransactions {
    enum ShowMovements {
        struct Request { }
        
        struct Response { 
            let filterDate: PFMDateFilter
            let totalExpenses: Double
            let expenses: TransactionsPerDateWithIdentifier
            let selectedCategory: String
        }
        
        struct ViewModel {
            let filterDate: String
            let totalExpenses: String
            let expenses: TransactionsPerDateWithIdentifier
            let selectedCategory: String
        }
    }
    
    enum FilterDate {
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
