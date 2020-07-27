//
//  ApprovalRequestCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/03/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

enum ApprovalStatus: String {
    case approved = "approved"
    case denied = "denied"
    case noAction = "no_action"

    var label: String {
        switch self {
        case .approved:
            return "Approved"
        case .denied:
            return "Denied"
        case .noAction:
            return "No action"
        }
    }
}

protocol ApprovalCellDelegate: class {
    func actionApprove(indexPath: IndexPath)
    func actionDeny(indexPath: IndexPath)
}

class ApprovalRequestCell: UITableViewCell {

    @IBOutlet weak private var lblModuleName: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var lblRequestDate: UILabel!
    @IBOutlet weak private var lblCustomer: UILabel!
    @IBOutlet weak private var lblTechnician: UILabel!
    @IBOutlet weak private var lblApprovalStatus: UILabel!
    @IBOutlet weak private var actionButtonsStackView: UIStackView!
    @IBOutlet weak private var deniedReasonStackView: UIStackView!
    @IBOutlet weak private var deleteReasonStackView: UIStackView!

    @IBOutlet weak private var lblDeniedReason: UILabel!

    @IBOutlet weak private var lblDeleteReasonTitle: UILabel!
    @IBOutlet weak private var lblDeleteReason: UILabel!
    @IBOutlet weak private var deleteLabelWidth: NSLayoutConstraint!

    weak var delegate: ApprovalCellDelegate?

    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: ApprovalRequestList.GetRequestData.Data) {
        lblModuleName.text = (model.module_name ?? "").uppercased()
        lblDescription.text = (model.description ?? "").capitalized
        lblRequestDate.text = model.updated_at ?? ""
        let name = "\(model.approval_request_details?.appointment?.customer_name ?? "") \(model.approval_request_details?.appointment?.customer_last_name ?? "")"
        lblCustomer.text = name.capitalized
        lblTechnician.text = (model.approval_request_details?.appointment?.requesting_technician ?? "").capitalized
        actionButtonsStackView.isHidden = true
        deniedReasonStackView.isHidden = true
        deleteReasonStackView.isHidden = true
        guard let status = ApprovalStatus(rawValue: model.approval_status ?? "") else {
            return
        }
        lblApprovalStatus.text = status.label
        lblDeniedReason.text = (model.denied_reason ?? "").firstUppercased
        deniedReasonStackView.isHidden = (status != .denied)
        actionButtonsStackView.isHidden = (status != .noAction)

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

    @IBAction func actionDeny(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.actionDeny(indexPath: indexPath)
        }
    }

    @IBAction func actionApprove(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.actionApprove(indexPath: indexPath)
        }
    }

}
