//
//  NotificationCenter+Name.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 13/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let didUpdateTransaction = NSNotification.Name(rawValue: "didUpdateTransaction")
    static let didUpdateService = NSNotification.Name(rawValue: "didUpdateService")
}
