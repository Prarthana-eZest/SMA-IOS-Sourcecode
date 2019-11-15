//
//  AppointmentStatusCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 07/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

protocol AppointmentDelegate:class {
    func actionDelete(indexPath:IndexPath)
    func actionModify(indexPath:IndexPath)
    func actionViewAll()
}

class AppointmentStatusCell: UITableViewCell {

    
    @IBOutlet private weak var statusColorView: UIView!
    @IBOutlet private weak var lblStartTime: UILabel!
    @IBOutlet private weak var lblEndTime: UILabel!
    @IBOutlet private weak var lblTotalDuration: UILabel!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblServiceName: UILabel!
    @IBOutlet private weak var btnServiceCount: UIButton!
    @IBOutlet private weak var lblRatings: UILabel!
    
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var locationStackView: UIStackView!
    
    
    weak var delegate:AppointmentDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model:AppointmentStatusModel){
        lblUserName.text = model.userName
        lblStartTime.text = model.startTimr
        lblEndTime.text = model.endTime
        lblTotalDuration.text = model.totalDuration
        lblServiceName.text = model.services.first
        btnServiceCount.setTitle("+\(model.services.count - 1)", for: .normal)
        statusColorView.backgroundColor = (model.status == .upcoming) ? UIColor(red: 145/255, green: 220/255, blue: 228/255, alpha: 1) : UIColor(red: 238/255, green: 91/255, blue: 70/255, alpha: 1)
        lblRatings.text = "\(model.ratings)/5"
        lblLocation.text = model.location
    }
    
    @IBAction func actionServiceCount(_ sender: UIButton) {
    }
    
}

enum AppointmentStatus{
    case upcoming,ongoing,completed
}

struct AppointmentStatusModel{
    let userName: String
    let services: [String]
    let appointmentStatus: String
    let startTimr: String
    let endTime: String
    let totalDuration: String
    let status: AppointmentStatus
    let ratings: Double
    let location: String
    let latitude: Double
    let langitude: Double
}
