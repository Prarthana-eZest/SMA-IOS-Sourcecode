//
//  MembershipStatusCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class MembershipStatusCell: UITableViewCell {

    @IBOutlet weak var membershipIcon: UIImageView!
    @IBOutlet weak var lblMemberType: UILabel!
    @IBOutlet weak var lblMembershipType: UILabel!
    @IBOutlet weak var lblValidUpTo: UILabel!
    @IBOutlet weak var lblRewardPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: MembershipStatusModel?) {
        if let model = model {

            lblMemberType.text = model.type.rawValue
            lblMembershipType.text = model.type.rawValue
            lblMembershipType.isHidden = false
            // Validity

            let validity: String
            let dateString = model.validity
            if let date = dateString.getDateFromShortString() {
                validity = date.monthYearDate
            } else {
                validity = model.validity
            }

            lblValidUpTo.text = "Valid up to \(validity)"
            lblValidUpTo.isHidden = model.type == .general
            membershipIcon.isHidden = model.type == .general

            switch model.type {

            case .general:break
            case .clubMemberShip:membershipIcon.image = UIImage(named: "ClubMembership")
            case .eliteMembership:membershipIcon.image = UIImage(named: "EliteMembership")
            case .premierMembership:membershipIcon.image = UIImage(named: "PremierMembership")
            }

            // Rewards Points
            lblRewardPoints.text = "Reward Points: \(model.rewardPoints)"
            lblRewardPoints.isHidden = true

        } else {

            lblMemberType.text = "No active membership"
            lblMembershipType.isHidden = true
            lblValidUpTo.isHidden = true
            membershipIcon.isHidden = true
            lblRewardPoints.isHidden = true
        }
    }

}

struct MembershipStatusModel {
    let type: MembershipType
    let validity: String
    let rewardPoints: String
}
