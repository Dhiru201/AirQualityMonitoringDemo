//
//  CityListViewModel.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import Foundation
import RxSwift
import RxCocoa

class CityListViewModel {

    var cityData = PublishSubject<[CityDataModel]>()
    var oldData: [CityDataModel] = [CityDataModel]()
    var dataSource: DataController?
    
    init(dataController: DataController) {
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

extension CityListViewModel: DataControllerDelegate {
    func didReceive(response: Result<[DataResponse], Error>) {
        switch response {

        case .success(let response):
            parseAndNotify(resArray: response)

        case .failure(let error):
            handleError(error: error)
        }
    }

    func parseAndNotify(resArray: [DataResponse]) {

        if oldData.count == 0 {
            for data in resArray {
                let model = CityDataModel(city: data.city)
                model.airQualityData.append(AQIModel(value: data.aqi, date: Date()))
                oldData.append(model)
            }
        } else {

            for response in resArray {
                let matchedResults = oldData.filter { $0.city == response.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.airQualityData.append(AQIModel(value: response.aqi, date: Date()))
                } else {
                    let model = CityDataModel(city: response.city)
                    model.airQualityData.append(AQIModel(value: response.aqi, date: Date()))
                    oldData.append(model)
                }
            }
        }
        cityData.onNext(oldData)
    }

    func handleError(error: Error?) {
        if let error = error {
            cityData.onError(error)
        }
    }
}
