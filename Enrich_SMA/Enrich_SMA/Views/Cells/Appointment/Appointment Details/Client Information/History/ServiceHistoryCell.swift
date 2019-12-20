//
//  ServiceHistoryCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit
import Cosmos

protocol ClientInformationDelegate:class {
    func actionOtherServices(indexPath:IndexPath)
}

class ServiceHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblServiceStatus: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var btnOtherServicesCount: UIButton!
    @IBOutlet weak var ratingsView: CosmosView!
    
    var indexPath: IndexPath?
    weak var delegate:ClientInformationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingsView.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(model: ClientInformation.GetAppointnentHistory.Data){
        
        if let dateString = model.appointment_date,
            let date = dateString.getDateFromString(){
            lblDateTime.text = date.dayNameDateFormat
        }else{
            lblDateTime.text = ""
        }
        
        lblServiceStatus.text = model.status ?? ""
        lblUserName.text = model.booked_by ?? ""
        lblServiceName.text = model.services?.first?.service_name ?? "Not available"
        btnOtherServicesCount.setTitle("+\((model.services?.count ?? 1) - 1)", for: .normal)
        ratingsView.rating = model.avg_rating ?? 0.0
    }
    
    @IBAction func actionOtherServices(_ sender: UIButton) {
        if let indexPath = indexPath{
            delegate?.actionOtherServices(indexPath: indexPath)
        }
    }
    
}


