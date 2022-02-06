//
//  UIColor_Extension.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        //
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        //
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        //
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat(rgbValue & 0x0000FF) / 255.0
        //
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
