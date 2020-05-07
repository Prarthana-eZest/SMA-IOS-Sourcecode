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
        lblDescription.text = (model.description ?? "").capitalized
        lblRequestDate.text = model.updated_at ?? ""
        let name = "\(model.approval_request_details?.appointment?.customer_name ?? "") \(model.approval_request_details?.appointment?.customer_last_name ?? "")"
        lblCustomer.text = name.capitalized
        lblTechnician.text = (model.approval_request_details?.appointment?.booking_technician ?? "").capitalized
        deniedReasonStackView.isHidden = true
        guard let status = ApprovalStatus(rawValue: model.approval_status ?? "") else {
            return
        }
        lblApprovalStatus.text = status.rawValue.capitalized
        lblDeniedReason.text = (model.denied_reason ?? "").capitalized
        deniedReasonStackView.isHidden = (status != .denied)
    }
}
