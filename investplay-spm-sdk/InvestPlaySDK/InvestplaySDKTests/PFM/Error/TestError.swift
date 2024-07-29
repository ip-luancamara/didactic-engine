//
//  TestError.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk

enum TestError: Swift.Error {
    case noResponseProvided
    case kmpError(Error)
}
