//
//  Calendar+Extension.swift
//
//
//  Created by Luan Câmara on 26/03/24.
//

import Foundation

extension Calendar {
    static var ptBR: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "pt_BR")
        return calendar
    }
}
