//
//  GraphDataModel.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import Foundation
import RxSwift
import RxCocoa


class GraphDataModel {
    
    var dataSource: DataController?
    
    var oldData: CityDataModel? = nil

    var graphdata = PublishSubject<CityDataModel>()
    var city:String!
    
    init(dataController: DataController, selectedCity:String) {
        city = selectedCity
        dataSource = dataController
        dataSource?.delegate = self
    }
    
    func subscribe() {
        dataSource?.subscribe()
    }

    func unsubscribe() {
        dataSource?.unsubscribe()
    }
    
}

extension GraphDataModel: DataControllerDelegate {
    
    func didReceive(response: Result<[DataResponse], Error>) {
        switch response {

        case .success(let response):
            parseAndNotify(resArray: response)

        case .failure(let error):
            handleError(error: error)
        }
    }

    func parseAndNotify(resArray: [DataResponse]) {
        let selectedCityData = resArray.filter { $0.city == city }
        if let data = selectedCityData.first {
            if let oldData = oldData {
                oldData.airQualityData.append(AQIModel(value: data.aqi, date: Date()))
            } else {
                oldData = CityDataModel(city: city)
                oldData?.airQualityData.append(AQIModel(value: data.aqi, date: Date()))
            }
        } else {
            if let oldData = oldData, let last = oldData.airQualityData.last {
                oldData.airQualityData.append(last)
            }
        }
    
        if let oldData = oldData {
            graphdata.onNext(oldData)
        }
    }

    func handleError(error: Error?) {
        if let error = error {
            graphdata.onError(error)
        }
    }
}
