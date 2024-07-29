//
//  File.swift
//  
//
//  Created by Luan Câmara on 05/03/24.
//

import Foundation

extension Array where Element: Numeric {
    var sum: Element { reduce(0, +) }
}

extension Int32 {
    var toInt: Int { Int(self) }
}

extension Int {
    var toInt32: Int32 { Int32(self) }
}
