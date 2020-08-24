//
//  AppointmentStatusCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 07/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

protocol AppointmentDelegate: class {
    func actionDelete(indexPath: IndexPath)
    func actionModify(indexPath: IndexPath)
    func actionViewAll()
    func servicesAction(indexPath: IndexPath)
    func actionRatings(indexPath: IndexPath)
}

enum ServiceType: String {
    case Salon = "salon"
    case Home = "home"
    case Belita = "belita"
}

enum PaymentStatus: String {

    case paymentPaid = "paid"
    case paymentUnpaid = "unpaid"

    var color: UIColor {
        switch self {
        case .paymentPaid:
            return UIColor(red: 34 / 255, green: 139 / 255, blue: 34 / 255, alpha: 1)
        case .paymentUnpaid:
            return UIColor(red: 232 / 255, green: 34 / 255, blue: 25 / 255, alpha: 1)
        }
    }
}

class AppointmentStatusCell: UITableViewCell {

    @IBOutlet private weak var statusColorView: UIView!
    @IBOutlet private weak var lblStartTime: UILabel!
    @IBOutlet private weak var lblEndTime: UILabel!
    @IBOutlet private weak var lblTotalDuration: UILabel!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblBookedBy: UILabel!
    @IBOutlet private weak var lblBookedFor: UILabel!

    @IBOutlet private weak var lblServiceName: UILabel!
    @IBOutlet private weak var btnServiceCount: UIButton!
    @IBOutlet private weak var lblRatings: UILabel!
    @IBOutlet private weak var stackViewServiceCount: UIStackView!

    @IBOutlet private weak var AddOnStackView: UIStackView!

    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var locationStackView: UIStackView!

    @IBOutlet private weak var lblPaymentStatus: UILabel!

    @IBOutlet private weak var iconHighSpending: UIImageView!

    let salonAppointmentColor = UIColor(red: 238 / 255, green: 91 / 255, blue: 71 / 255, alpha: 1)
    let belitaAppointmentColor = UIColor(red: 135 / 255, green: 197 / 255, blue: 205 / 255, alpha: 1)

    weak var delegate: AppointmentDelegate?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: Appointment.GetAppointnents.Data) {

        // Add On Flow
        if model.booked_by_id == model.booked_for_id {
            lblUserName.isHidden = false
            AddOnStackView.isHidden = true
            lblUserName.text = model.booked_by ?? ""
        }
        else {
            lblUserName.isHidden = true
            AddOnStackView.isHidden = false
            lblBookedBy.text = model.booked_by ?? ""
            lblBookedFor.text = model.booked_for ?? ""
        }

        lblStartTime.text = model.start_time ?? ""
        lblEndTime.text = model.end_time ?? ""
        lblTotalDuration.text = "\(model.total_duration ?? 0) min"
        lblServiceName.text = model.services?.first?.service_name ?? "Not available"
        btnServiceCount.setTitle("+\((model.services?.count ?? 1) - 1)", for: .normal)
        stackViewServiceCount.isHidden = ((model.services?.count ?? 1) < 2)
        //lblAppointmentStatus.text = "\(model.status ?? "")"
        var address = [String]()
        if let address1 = model.customer_address {
            address.append(address1)
        }
        if let address2 = model.customer_address2 {
            address.append(address2)
        }
        lblLocation.text = address.joined(separator: ", ")
        locationStackView.isHidden = true
        let rating = model.avg_rating ?? 0
        lblRatings.text = "\(rating.cleanForRating)/5"

        statusColorView.backgroundColor = salonAppointmentColor

        if let paymentStatus = PaymentStatus(rawValue: model.payment_status ?? "unpaid") {
            lblPaymentStatus.text = paymentStatus.rawValue.uppercased()
            lblPaymentStatus.textColor = paymentStatus.color
        }

        if let highSpending = model.high_expensive, highSpending == true {
            iconHighSpending.isHidden = false
        }
        else {
            iconHighSpending.isHidden = true
        }

        if let typeText = model.appointment_type,
            let type = ServiceType(rawValue: typeText) {
            locationStackView.isHidden = (type == .Salon)
            statusColorView.backgroundColor = (type == .Salon) ? salonAppointmentColor : belitaAppointmentColor
        }
    }

    @IBAction func actionServiceCount(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.servicesAction(indexPath: indexPath)
        }
    }

    @IBAction func actionRatings(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.actionRatings(indexPath: indexPath)
        }
    }

}
