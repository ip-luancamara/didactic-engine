//
//  InvestplaySDKActionsSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 22/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@testable import InvestplaySDK

class InvestplaySDKActionsSpy: InvestplaySDKActionDelegate {
    
    var wasDidTapRightButtonCalled = false
    var didTapRightButtonCompletionHandler: ((InvestplaySDKScreen) -> Void)?
    
    var wasGoToMainScreenCalled = false
    var goToMainScreenCalledCompletionHandler: (() -> Void)?

    func didTapRightButton(on screen: InvestplaySDKScreen) {
        wasDidTapRightButtonCalled = true
        didTapRightButtonCompletionHandler?(screen)
    }

    func goToMainScreen() {
        wasGoToMainScreenCalled = true
        goToMainScreenCalledCompletionHandler?()
    }
}
