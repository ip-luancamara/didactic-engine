//
//  PFMExpensesModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 07/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

typealias IdentifiableCategories = [(UDSSpendingChartModel, String)]

enum PFMExpenses {
    enum ShowCategories {
        struct Request { }
        
        struct Response {
            let filterDate: PFMDateFilter
            let totalExpenses: Double
            let categories: IdentifiableCategories
        }
        
        struct ViewModel { 
            let filterDate: String
            let totalExpenses: String
            let categories: IdentifiableCategories
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
    
    enum ShowTransactions {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
