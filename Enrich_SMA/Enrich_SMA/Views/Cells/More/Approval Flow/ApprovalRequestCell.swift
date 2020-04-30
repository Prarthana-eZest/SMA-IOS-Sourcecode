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
}

class ApprovalRequestCell: UITableViewCell {

    @IBOutlet weak private var lblModuleName: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var lblRequestDate: UILabel!
    @IBOutlet weak private var lblCustomer: UILabel!
    @IBOutlet weak private var lblTechnician: UILabel!
    @IBOutlet weak private var lblApprovalStatus: UILabel!
    @IBOutlet weak private var actionButtonsStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: ApprovalRequestList.GetRequestData.Data) {
        lblModuleName.text = (model.module_name ?? "").uppercased()
        lblDescription.text = model.description ?? ""
        lblRequestDate.text = model.updated_at ?? ""
        lblCustomer.text = (model.customer_name ?? "").capitalized
        lblTechnician.text = (model.technician_name ?? "").capitalized
        actionButtonsStackView.isHidden = true
        guard let status = ApprovalStatus(rawValue: model.approval_status ?? "") else {
            return
        }
        lblApprovalStatus.text = status.rawValue.capitalized
        actionButtonsStackView.isHidden = (status != .noAction)
    }

    @IBAction func actionDeny(_ sender: UIButton) {
    }

    @IBAction func actionApprove(_ sender: UIButton) {
    }

}
