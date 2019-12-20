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
    func servicesAction(indexPath:IndexPath)
}

enum ServiceType:String{
    case Salon = "salon"
    case Belita = "home"
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
    
    let salonAppointmentColor = UIColor(red: 238/255, green: 91/255, blue: 71/255, alpha: 1)
    let belitaAppointmentColor = UIColor(red: 135/255, green: 197/255, blue: 205/255, alpha: 1)

    
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
    
    func configureCell(model:Appointment.GetAppointnents.Data){
        lblUserName.text = model.booked_by ?? ""
        lblStartTime.text = model.start_time ?? ""
        lblEndTime.text = model.end_time ?? ""
        lblTotalDuration.text = "\(model.total_duration ?? "0") min"
        lblServiceName.text = model.services?.first?.service_name ?? "Not available"
        btnServiceCount.setTitle("+\((model.services?.count ?? 1) - 1)", for: .normal)
        //lblAppointmentStatus.text = "\(model.status ?? "")"
        lblLocation.text = model.customer_address ?? ""
        locationStackView.isHidden = true
        let rating = model.avg_rating ?? 0
        if rating == 0{
            lblRatings.text = "0/5"
        }else{
            lblRatings.text = "\(rating)/5"
        }
        statusColorView.backgroundColor = salonAppointmentColor

        if let typeText = model.appointment_type,
            let type = ServiceType(rawValue: typeText){
            locationStackView.isHidden = (type == .Salon)
            statusColorView.backgroundColor = (type == .Salon) ? salonAppointmentColor : belitaAppointmentColor
        }
    }
    
    @IBAction func actionServiceCount(_ sender: UIButton) {
        if let indexPath = indexPath{
            delegate?.servicesAction(indexPath: indexPath)
        }
    }
    
}

