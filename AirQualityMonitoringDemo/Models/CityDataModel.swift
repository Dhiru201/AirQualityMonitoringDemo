//
//  CityDataModel.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import Foundation

class CityDataModel {
    var city: String
    var airQualityData: [AQIModel] = [AQIModel]()
    
    init(city: String) {
        self.city = city
    }
}
