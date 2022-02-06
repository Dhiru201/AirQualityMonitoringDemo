//
//  AirQualityGraphVC.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class AirQualityGraphVC: UIViewController {
    
    var cityModel: CityDataModel?
    
    private var disposeBag = DisposeBag()
    
    private let chartView = LineChartView()
    
    var dataEntries = [ChartDataEntry]()
    
    private var selectedCity:String!
    private var viewModel: GraphDataModel?
    
    // Determine how many dataEntries show up in the chartView
    var xValue: Double = 30
    
    init(cityModel: CityDataModel) {
        super.init(nibName: nil, bundle: nil)
        self.cityModel = cityModel
        self.selectedCity = cityModel.city
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let dataSource = DataController()
        viewModel = GraphDataModel(dataController: dataSource, selectedCity: selectedCity)
        
        self.title = selectedCity
        
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupInitialDataEntries()
        
        setupChartData()
        
        bindData()
    }
    
    func bindData() {

        viewModel?.graphdata.bind { model in

            if let v = model.airQualityData.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)

                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }

        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // subscribe
        viewModel?.subscribe()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // unsubscribe
        viewModel?.unsubscribe()
    }
}

// Graph UI
extension AirQualityGraphVC {
    
    func setupInitialDataEntries() {
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    func setupChartData() {
        //
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: self.selectedCity + " Air Quality Graph")
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = true
        chartDataSet.fillColor = Colors.graphLine
        chartDataSet.setColor(Colors.graphLine)
        chartDataSet.mode = .linear
        chartDataSet.lineWidth = 3
        chartDataSet.setCircleColor(Colors.graphLine)
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 12)
        //
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        //
        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)
        //
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
    
}

