//
//  UIColor+HexColor.swift
//  PokeDex
//
//  Created by Caue Camara on 07/05/23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String?, alpha: CGFloat = 1.0) {
        guard let hexString else {
            self.init(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 0
            )

            return
        }

        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            red = 1
            green = 1
            blue = 1
        } else {
            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var hex: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
