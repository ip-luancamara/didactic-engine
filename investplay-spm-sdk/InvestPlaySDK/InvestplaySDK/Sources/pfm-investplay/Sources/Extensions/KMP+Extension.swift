//
//  KMP+Extension.swift
//
//
//  Created by Luan Câmara on 21/03/24.
//

import Foundation
import NetworkSdk
import UIKit
@_implementationOnly import DesignSystem

extension Kotlinx_datetimeInstant {
    static var now: Kotlinx_datetimeInstant {
        Kotlinx_datetimeInstant.companion.fromEpochSeconds(
            epochSeconds: Int64(
                Date().timeIntervalSince1970
            ),
            nanosecondAdjustment: 0
        )
    }

    func toDate() -> Date {
        Date(
            timeIntervalSince1970:
                Double(
                    self.toEpochMilliseconds()
                ) / 1000
        )
    }
}

extension Kotlinx_datetimeLocalDate {
    static var threeMonthAgo: Kotlinx_datetimeLocalDate {
        let currentDate = Date()
        
        let threeMonthAgo = Calendar.ptBR.date(byAdding: .month, value: -3, to: currentDate)
        
        return Kotlinx_datetimeLocalDate(
            year: threeMonthAgo!.year,
            monthNumber: threeMonthAgo!.month,
            dayOfMonth: 1
        )
    }
    
    static var twoMonthAgo: Kotlinx_datetimeLocalDate {
        let currentDate = Date()
        
        let threeMonthAgo = Calendar.ptBR.date(byAdding: .month, value: -2, to: currentDate)

        return Kotlinx_datetimeLocalDate(
            year: threeMonthAgo!.year,
            monthNumber: threeMonthAgo!.month,
            dayOfMonth: 1
        )
    }

    static var now: Kotlinx_datetimeLocalDate {
        let currentDate = Date()
        return Kotlinx_datetimeLocalDate(
            year: currentDate.year,
            monthNumber: currentDate.month,
            dayOfMonth: currentDate.day
        )
    }
}

extension SpendingsLevelColor {
    var theme: Theme {
        Theme()
    }

    var color: UIColor {
        switch self {
        case .red:
            return theme.contentColors.negative
        case .yellow:
            return theme.colors.secondary300
        case .green:
            return theme.contentColors.positive
        default:
            return .clear
        }
    }
}
