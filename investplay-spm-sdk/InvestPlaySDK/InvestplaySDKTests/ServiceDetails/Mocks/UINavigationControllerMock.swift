//
//  UINavigationControllerMock.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

class UINavigationControllerMock: UINavigationController {

    var wasPopViewControllerCalled = false
    var popViewControllerCompletionHandler: ((Bool) -> UIViewController?)?

    override func popViewController(animated: Bool) -> UIViewController? {
        wasPopViewControllerCalled = true
        return popViewControllerCompletionHandler?(animated)
    }

}
