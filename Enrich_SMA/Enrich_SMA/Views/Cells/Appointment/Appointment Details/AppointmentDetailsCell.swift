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
    @IBOutlet weak private var lblDateTime: UILabel!
    @IBOutlet weak private var userProfile: UIImageView!
    @IBOutlet weak private var lblUserName: UILabel!
    @IBOutlet weak private var lblAppointmentStatus: UILabel!
    @IBOutlet weak private var lblLastVisit: UILabel!
    @IBOutlet weak private var lblRatings: UILabel!

    // Status
    @IBOutlet weak private var lblStatus: UILabel!
    @IBOutlet weak private var lblStartTime: UILabel!
    @IBOutlet weak private var lblEndTime: UILabel!
    @IBOutlet weak private var lblTotalDuration: UILabel!
    @IBOutlet weak private var lblLocation: UILabel!

    @IBOutlet weak private var locationStackView: UIStackView!

    @IBOutlet weak private var lblLandmark: UILabel!

    @IBOutlet weak private var iconMembership: UIImageView!
    @IBOutlet weak private var dividerView: UIView!

    @IBOutlet weak private var iconHighSpending: UIImageView!

    @IBOutlet weak private var stackViewMemAndHighS: UIStackView!

    var appointmentDetails: Appointment.GetAppointnents.Data?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: Appointment.GetAppointnents.Data, date: Date) {

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
        lblRatings.text = "\(rating.cleanForRating)/5"

        lblTotalDuration.text = "\(model.total_duration ?? 0) min"

        locationStackView.isHidden = true
        if let typeText = model.appointment_type,
            let type = ServiceType(rawValue: typeText) {
            locationStackView.isHidden = (type == .Salon)
        }

        lblLandmark.text = model.landmark ?? "-"

        userProfile.layer.cornerRadius = userProfile.frame.size.height * 0.5
        userProfile.kf.indicatorType = .activity

        let defaultImage = UIImage(named: "defaultProfile")
        if let url = model.profile_picture ,
            let imageurl = URL(string: url) {
            userProfile.kf.setImage(with: imageurl, placeholder: defaultImage, options: nil, progressBlock: nil, completionHandler: nil)
        }
        else {
            userProfile.image = defaultImage
        }

        // Memebership

        var isMember = false
        dividerView.isHidden = true
        stackViewMemAndHighS.isHidden = false

        if let memebrshipType = MembershipType(rawValue: model.membership ?? "") {
            switch memebrshipType {

            case .general:
                isMember = false

            case .clubMemberShip:
                iconMembership.image = UIImage(named: "ClubMembership")
                isMember = true

            case .eliteMembership:
                iconMembership.image = UIImage(named: "EliteMembership")
                isMember = true

            case .premierMembership:
                iconMembership.image = UIImage(named: "PremierMembership")
                isMember = true
            }
        }

        iconMembership.isHidden = !isMember

        if let highSpending = model.high_expensive, highSpending == true {
            iconHighSpending.isHidden = false
        }
        else {
            iconHighSpending.isHidden = true
            if !isMember {
                stackViewMemAndHighS.isHidden = true
            }
        }
    }

    @IBAction func actionFindAddress(_ sender: UIButton) {
        if let model = appointmentDetails,
            let lat = model.customer_latitude,
            let long = model.customer_longitude {
            ApplicationFactory.shared.openGoogleMaps(lat: lat, long: long)
        }
    }
}
