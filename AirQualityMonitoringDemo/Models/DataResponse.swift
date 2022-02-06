//
//  DataResponse.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import Foundation

struct DataResponse: Codable {
    var city: String
    var aqi: Float
    
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
