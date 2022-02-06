//
//  Contants.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit

struct APIHelper {
    public static var url: String = "ws://city-ws.herokuapp.com/"
}

enum Colors {
    static let tableBG: UIColor = UIColor(hexString: "#EEEEEE")
    static let graphLine: UIColor = UIColor(hexString: "#0852E7")
    
    // AQI Colors
    static let goodState: UIColor = UIColor(hexString: "#2ba023")
    static let satisfactoryeState: UIColor = UIColor(hexString: "#93c47d")
    static let moderateState: UIColor = UIColor(hexString: "#FDE333")
    static let poorState: UIColor = UIColor(hexString: "#bf9000")
    static let veryPoorState: UIColor = UIColor(hexString: "#f44336")
    static let severeState: UIColor = UIColor(hexString: "#cc0000")
    static let noneState: UIColor = UIColor(hexString: "#ffffff")
    
}

struct Cells {
    static let cityListTableCellId = "CityListTableCell"
}

enum AirQualityGrading {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case none
}
