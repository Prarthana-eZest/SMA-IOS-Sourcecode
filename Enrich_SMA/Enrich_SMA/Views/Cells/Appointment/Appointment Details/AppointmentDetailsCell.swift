//
//  AppointmentDetailsCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 07/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class AppointmentDetailsCell: UITableViewCell {
    
    
    //Appointment Details
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAppointmentStatus: UILabel!
    @IBOutlet weak var lblLastVisit: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    
    // Status
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var locationStackView: UIStackView!
    
    @IBOutlet weak var lblLandmark: UILabel!
    
    var appointmentDetails: Appointment.GetAppointnents.Data?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(model:Appointment.GetAppointnents.Data,date:Date){
        
        appointmentDetails = model
        lblUserName.text = model.booked_by ?? ""
        lblStartTime.text = model.start_time ?? ""
        lblEndTime.text = model.end_time ?? ""
        lblTotalDuration.text = "\(model.total_duration ?? 0) min"
        
        let status = model.status ?? ""
        lblAppointmentStatus.text = status.uppercased()
        lblStatus.text = status.uppercased()
        
        lblLocation.text = model.customer_address ?? ""
        lblDateTime.text = date.dayNameDateFormat
        lblLastVisit.text = model.last_visit ?? ""
        
        let rating = model.avg_rating ?? 0
        if rating == 0{
            lblRatings.text = "0/5"
        }else{
            lblRatings.text = "\(rating)/5"
        }
        
        lblTotalDuration.text = "\(model.total_duration ?? 0) min"
        
        locationStackView.isHidden = true
        if let typeText = model.appointment_type,
            let type = ServiceType(rawValue: typeText){
            locationStackView.isHidden = (type == .Salon)
        }
        
        lblLandmark.text = model.landmark ?? "-"
        
        userProfile.layer.cornerRadius = userProfile.frame.size.height * 0.5
        let url = URL(string: "" )
        userProfile.kf.indicatorType = .activity
        
        let defaultImage = UIImage(named: "defaultProfile")
        if let imageurl = url{
            userProfile.kf.setImage(with: imageurl, placeholder: defaultImage, options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            userProfile.image = defaultImage
        }
    }
    
    @IBAction func actionFindAddress(_ sender: UIButton) {
        if let model = appointmentDetails,
            let lat = model.customer_latitude,
            let long = model.customer_longitude{
            appDelegate.openGoogleMaps(lat: lat, long: long)
        }
    }
}

