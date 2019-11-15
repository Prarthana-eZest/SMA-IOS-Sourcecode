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
    
    var model : AppointmentDetailsModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(model:AppointmentDetailsModel){
        lblDateTime.text = model.dateTime
        lblUserName.text = model.userName
        lblAppointmentStatus.text = model.appointmentStatus
        lblLastVisit.text = model.lastVisit
        lblRatings.text = "\(model.ratings)/5"
        lblStatus.text = model.timeStatus
        lblStartTime.text = model.startTimer
        lblEndTime.text = model.endTime
        lblTotalDuration.text = model.totalDuration
        lblLocation.text = model.location
        locationStackView.isHidden = model.location.isEmpty
    }
    
    @IBAction func actionFindAddress(_ sender: UIButton) {
        if let model = model{
            appDelegate.openGoogleMaps(lat: model.latitude, long: model.longitude)
        }
    }
    
    
}

struct AppointmentDetailsModel{
    
    let dateTime: String
    let appointmentStatus: String
    let userName: String
    let profilePictureURL:String
    let ratings: Double
    let lastVisit: String
    let timeStatus: String
    let startTimer: String
    let endTime: String
    let totalDuration: String
    let location: String
    let latitude: Double
    let longitude: Double
}

