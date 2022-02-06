//
//  AirQualityRating.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit


class AirQualityIndex {
    
    public func color(value :Float) -> UIColor {
        let index = airQualityGradingCalculator(value: value)
        //
        switch index {
        case .good:
            return Colors.goodState
        case .satisfactory:
            return Colors.satisfactoryeState
        case .moderate:
            return Colors.moderateState
        case .poor:
            return Colors.poorState
        case .veryPoor:
            return Colors.veryPoorState
        case .severe:
            return Colors.severeState
        case .none:
            return Colors.noneState
        }
    }
    
    private func airQualityGradingCalculator(value: Float) -> AirQualityGrading {
        switch value {
        case 0...50:
            return .good
        case 50.000001...100:
            return .satisfactory
        case 100.000001...200:
            return .moderate
        case 200.000001...300:
            return .poor
        case 300.000001...400:
            return .veryPoor
        case 400.000001...500:
            return .severe
        default:
            return .none
        }
    }
}

