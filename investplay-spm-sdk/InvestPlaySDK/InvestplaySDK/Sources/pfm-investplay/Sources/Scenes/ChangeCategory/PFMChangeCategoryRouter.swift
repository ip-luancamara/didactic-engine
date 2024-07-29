//
//  PFMChangeCategoryRouter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit

@objc protocol PFMChangeCategoryRoutingLogic {
    func routeToTransactionDetails(completion: (() -> Void)?)
}

protocol PFMChangeCategoryDataPassing {
    var dataStore: PFMChangeCategoryDataStore? { get }
}

class PFMChangeCategoryRouter: NSObject, PFMChangeCategoryRoutingLogic, PFMChangeCategoryDataPassing {
    weak var viewController: PFMChangeCategoryViewController?
    var dataStore: PFMChangeCategoryDataStore?
    
    // MARK: Routing
    
    func routeToTransactionDetails(
        completion: (() -> Void)? = nil
    ) {
        defer {
            completion?()
        }
        
        viewController?.navigationController?.popViewController(animated: true)
    }
}
