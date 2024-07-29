//
//  PFMChangeCategoryModels.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

typealias IdentifiableSpendingViewModel = (viewModel: PFMCategory, id: String)

struct PFMCategory {
    let title: String
    let icon: UIImage
    let showDivider: Bool
    let indicatorColor: UIColor
    let tag: UDSTagModel?
    let delegate: UDSSpendingActionViewModelDelegate?
    
    func toUDSViewModel() -> UDSSpendingActionViewModel {
        return UDSSpendingActionViewModel(
            title: title,
            icon: icon,
            showDivider: showDivider,
            indicatorColor: indicatorColor,
            tag: tag,
            delegate: delegate
        )
    }
}

enum PFMChangeCategory {
  
    // MARK: Use cases
    struct ChangeCategory {
        struct Request { }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
            let success: Bool
        }
    }
    
    struct GetCategories {
        struct Request { }
        
        struct Response {
            let categories: [CategoryData]
            let selectedCategoryId: String
            let selectedCategoryName: String
            let delegate: UDSSpendingActionViewModelDelegate
        }
        
        struct ViewModel {
            let categories: [IdentifiableSpendingViewModel]
            let selectedCategoryName: String
        }
    }
    
    struct Loading {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
