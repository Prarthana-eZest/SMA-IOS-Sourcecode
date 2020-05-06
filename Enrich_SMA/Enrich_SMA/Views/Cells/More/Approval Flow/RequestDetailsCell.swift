//
//  RequestDetailsCell.swift
//  Enrich_SMA
//
//  Created by Harshal on 05/05/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class RequestDetailsCell: UITableViewCell {

    @IBOutlet weak private var lblModuleName: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var lblRequestDate: UILabel!
    @IBOutlet weak private var lblCustomer: UILabel!
    @IBOutlet weak private var lblTechnician: UILabel!
    @IBOutlet weak private var lblApprovalStatus: UILabel!
    @IBOutlet weak private var deniedReasonStackView: UIStackView!
    @IBOutlet weak private var lblDeniedReason: UILabel!
    @IBOutlet weak private var lblAppointmentDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: ApprovalRequestList.GetRequestData.Data, date: String) {
        lblAppointmentDate.text = date
        lblModuleName.text = (model.module_name ?? "").uppercased()
        lblDescription.text = model.description ?? ""
        lblRequestDate.text = model.updated_at ?? ""
        lblCustomer.text = (model.customer_name ?? "").capitalized
        lblTechnician.text = (model.technician_name ?? "").capitalized
        deniedReasonStackView.isHidden = true
        guard let status = ApprovalStatus(rawValue: model.approval_status ?? "") else {
            return
        }
        lblApprovalStatus.text = status.rawValue.capitalized
        lblDeniedReason.text = (model.denied_reason ?? "").capitalized
        deniedReasonStackView.isHidden = (status != .denied)
    }
}
