//
//  ViewController.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit
import RxCocoa
import RxSwift

class CityListVC: UIViewController {
    
    private var cityListTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private var viewModel: CityListViewModel?
    private var disposeBag = DisposeBag()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init view model
        initVM()
        // Init view
        initView()
    }
    
    //Mark: Setup View Methods
    func initView() {
        self.view.addSubview(cityListTable)
        //
        let safeLayoutGuide = view.safeAreaLayoutGuide
        cityListTable.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor).isActive = true
        cityListTable.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor).isActive = true
        cityListTable.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        cityListTable.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor).isActive = true
        //
        // Register cells
        cityListTable.register(UINib(nibName: Cells.cityListTableCellId, bundle: nil), forCellReuseIdentifier: Cells.cityListTableCellId)
        cityListTable.backgroundColor = Colors.tableBG
        cityListTable.separatorStyle = .none
    }
    
    func initVM() {
        let dataSource = DataController()
        
        viewModel = CityListViewModel(dataController: dataSource)
        
        viewModel?.cityData.bind(to: cityListTable.rx.items(cellIdentifier: Cells.cityListTableCellId, cellType: CityListTableCell.self)) {row, model, cell in
            cell.cityCellData = model
        }.disposed(by: disposeBag)
        
        // set delegate
        cityListTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        //
        // bind a model selected handler
        cityListTable.rx.modelSelected(CityDataModel.self).bind { item in
            print(item)
            let graphVC = AirQualityGraphVC(cityModel: item)
            self.navigationController?.pushViewController(graphVC, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to AQIs Socket Connection
        viewModel?.subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
    deinit {
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
   
}

extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}



    
    
