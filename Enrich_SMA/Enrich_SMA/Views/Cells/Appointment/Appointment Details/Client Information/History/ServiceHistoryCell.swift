//
//  ServiceHistoryCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit
import Cosmos

class ServiceHistoryCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblServiceStatus: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var btnOtherServicesCount: UIButton!
    @IBOutlet weak var ratingsView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model:HistoryServiceModel){
        lblDateTime.text = model.dateTime
        lblServiceStatus.text = model.serviceStatus
        lblUserName.text = model.userName
        lblServiceName.text = model.services.first ?? ""
        btnOtherServicesCount.setTitle("+\(model.services.count - 1)", for: .normal)
    }
    
    @IBAction func actionOtherServices(_ sender: UIButton) {
    }
    
    
}


struct HistoryServiceModel{
    let userName: String
    let dateTime: String
    let rating: Double
    let services: [String]
    let serviceStatus: String
}
