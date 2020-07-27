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
    @IBOutlet weak private var deleteReasonStackView: UIStackView!

    @IBOutlet weak private var lblDeniedReason: UILabel!
    @IBOutlet weak private var lblDeleteReason: UILabel!
    @IBOutlet weak private var lblAppointmentDate: UILabel!

    @IBOutlet weak private var lblDeleteReasonTitle: UILabel!
    @IBOutlet weak private var deleteLabelWidth: NSLayoutConstraint!

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
        lblTechnician.text = (model.approval_request_details?.appointment?.requesting_technician ?? "").capitalized
        deniedReasonStackView.isHidden = true
        guard let status = ApprovalStatus(rawValue: model.approval_status ?? "") else {
            return
        }
        lblApprovalStatus.text = status.label
        lblDeniedReason.text = (model.denied_reason ?? "").firstUppercased
        deniedReasonStackView.isHidden = (status != .denied)

        if let category = ModifyRequestCategory(rawValue: model.category ?? "") {
            var deleteReason = ""
            if category == .can_appointment {
                deleteReason = model.approval_request_details?.appointment?.cancel_reason ?? ""
                deleteLabelWidth.constant = 158
                lblDeleteReasonTitle.text = "Cancellation Reason :"
            }
            if category == .del_service {
                deleteReason = model.approval_request_details?.service?.first?.delete_reason ?? ""
                deleteLabelWidth.constant = 128
                lblDeleteReasonTitle.text = "Deletion Reason :"
            }
            lblDeleteReason.text = deleteReason
            deleteReasonStackView.isHidden = deleteReason.isEmpty
        }
    }
}
