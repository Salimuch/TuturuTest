//
//  StationInfoTableView.swift
//  TuturuTest
//
//  Created by Артем on 23/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class StationInfoTableView: UITableViewController {
    
    // MARK: Model
    var station: Station?
    
    // MARK: Outlets
    
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    private func updateUI() {
        stationName.text = station?.stationName
        country.text = station?.country
        city.text = station?.city
        additionalInfo.text = "\(station?.region ?? "") \(station?.district ?? "")"
    }

    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        updateUI()
    }

}
