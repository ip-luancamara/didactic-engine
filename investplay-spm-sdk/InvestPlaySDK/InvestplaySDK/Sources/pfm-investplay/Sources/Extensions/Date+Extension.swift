//
//  Date+Extension.swift
//
//
//  Created by Luan Câmara on 21/03/24.
//

import Foundation

extension Date {
    func formatted(as format: String, locale identifier: String = "pt_BR") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var day: Int32 {
        Int32(Calendar.ptBR.component(.day, from: self))
    }

    var month: Int32 {
        Int32(Calendar.ptBR.component(.month, from: self))
    }

    var year: Int32 {
        Int32(Calendar.ptBR.component(.year, from: self))
    }

    func toCreditCardDueDate() -> String {
        "\(formatted(as: "dd")) \(formatted(as: "MMM").replacingOccurrences(of: ".", with: "").uppercased())"
    }
    
    // Sexta-feira, 5 de janeiro de 2024
    func toFullString() -> String {
        formatted(as: "EEEE, dd 'de' MMMM 'de' yyyy").capitalizedSentence
    }
    
    func toUpdatedAt() -> String {
        "Dados recebidos no dia \(formatted(as: "dd/MM/yy")) às \(formatted(as: "HH"))h\(formatted(as: "mm"))min."
    }
}
