//
//  Logger.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 28/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import OSLog

protocol PFMLoggerProtocol {
    func log(_ message: String)
    func log(_ error: Error)
}

struct PFMLogger: PFMLoggerProtocol {
    
    let className: AnyClass
    
    @available(iOS 14.0, *)
    static let osLogger = Logger(subsystem: "com.investplay.sdk", category: "InvestplaySDK")
    
    func log(_ message: String) {
        if #available(iOS 14.0, *) {
            PFMLogger.osLogger.log(level: .debug, "[Investplay SDK][\(className)]: \(message)")
        } else {
            debugPrint("[Investplay SDK][\(className)]: \(message)")
        }
    }
    
    func log(_ error: Error) {
        if #available(iOS 14.0, *) {
            PFMLogger.osLogger.log(level: .error, "[Investplay SDK][\(className)]: \(error.localizedDescription)")
        } else {
            debugPrint("[Investplay SDK][\(className)]: \(error.localizedDescription)]")
        }
    }
}
