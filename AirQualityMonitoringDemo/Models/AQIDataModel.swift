//
//  AQIDataModel.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import Foundation
import UIKit

class AQIModel {
    var value:Float = 0.0
    var date:Date = Date()
    
    init(value: Float, date: Date) {
        self.value = value
        self.date = date
    }
    
    var timeString:String {
        if date.timeAgo() == "0 seconds" {
            return "just now"
        } else {
            return date.timeAgo() + " ago"
        }
    }
    
    var aqiValue:String {
         return String(format: "%.2f", value)
    }
    
    var airQualityIndicationColor:UIColor {
        let color = AirQualityIndex().color(value: value)
            return color
    }
    
}
