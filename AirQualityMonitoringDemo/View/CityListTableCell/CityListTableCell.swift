//
//  CityListTableCell.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//

import UIKit

class CityListTableCell: UITableViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet var cityLbl: UILabel?
    @IBOutlet var qualityLbl: UILabel?
    @IBOutlet var timeLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        cellContainerView?.layer.cornerRadius = 8
        cellContainerView?.layer.masksToBounds = true
    }
    
    var cityCellData: CityDataModel? {
        didSet {
            guard let data = cityCellData else { return }
             cityLbl?.text = data.city

            if let aqiValue = data.airQualityData.last?.aqiValue {
                qualityLbl?.text = aqiValue
            }else{
                qualityLbl?.text = "-"
            }
            //
            cellContainerView?.backgroundColor = data.airQualityData.last?.airQualityIndicationColor
            //
            if let time = data.airQualityData.last?.timeString {
                timeLbl?.text = time
            } else {
                timeLbl?.text = "-"
            }
        }
    }
}

