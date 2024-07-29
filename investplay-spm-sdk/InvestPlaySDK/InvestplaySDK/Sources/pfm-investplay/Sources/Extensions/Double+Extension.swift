//
//  Double+Extension.swift
//  
//
//  Created by Luan Camara on 19/10/22.
//

import Foundation

extension Double {
    func formattedAsBRL(
        decimalPlaces: Int = 2
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .ptBr
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimalPlaces
        formatter.negativePrefix = "-R$"
        return formatter.string(
            from: self as NSNumber
        ) ?? ""
    }
}
