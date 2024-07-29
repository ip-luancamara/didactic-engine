//
//  PFMTransactionDetailsModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
@_implementationOnly import DesignSystem

enum PFMTransactionDetails {
  
    // MARK: Use cases
    struct TransactionDetails {
        
        struct Request { }
        
        struct Response {
            let type: PFMTransactionDetailsType
            let title: String
            let value: Double
            let date: Date
            let fromTitle: String
            let fromSubtitle: String
            let fromImageURL: String
            let category: UDSSpendingActionViewModel
            let isIgnored: Bool
        }
        
        struct ViewModel {
            let type: PFMTransactionDetailsType
            let title: String
            let value: String
            let date: String
            let fromTitle: String
            let fromSubtitle: String
            let fromImageURL: String
            let category: UDSSpendingActionViewModel
            let isIgnored: Bool
        }
    }
    
    struct ChangeCategory {
        struct Request { }
        
        struct Response {
            let delegate: PFMChangeCategoryDelegate
        }
        
        struct ViewModel {
            let delegate: PFMChangeCategoryDelegate
        }
    }
    
    struct ChangeIgnoreSpendingFlag {
        struct Request { 
            let shouldIgnore: Bool
        }
        
        struct Response { 
            let success: Bool
        }
        
        struct ViewModel {
            let success: Bool
        }
    }
}
