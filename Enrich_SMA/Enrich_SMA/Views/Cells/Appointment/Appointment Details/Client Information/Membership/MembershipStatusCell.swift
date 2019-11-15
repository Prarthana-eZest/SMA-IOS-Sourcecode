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
    
    
    func configureCell(model:MembershipStatusModel){
        lblMemberType.text = model.memberType
        lblMembershipType.text = model.membershipType
        lblValidUpTo.text = "Valid up to \(model.validity)"
        lblRewardPoints.text = "Reward Points: \(model.rewardPoints)"
    }
    
}

struct MembershipStatusModel{
    
    let memberType: String
    let membershipType: String
    let validity: String
    let rewardPoints: String
}
