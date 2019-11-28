//
//  DashboardProfileCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

protocol DashboardHeaderCellDelegate: class {
    func locationUpdateAction()
    func locationDetailViewUpdate()
}

class DashboardProfileCell: UITableViewCell {
    

    @IBOutlet weak private var btnSelectALocation: UIButton!
    @IBOutlet weak private var locationNameView: UIStackView!
    @IBOutlet weak private var lblUserName: UILabel!
    @IBOutlet weak private var lblDesignation: UILabel!
    @IBOutlet weak private var profilePicture: UIImageView!
    @IBOutlet weak private var lblRating: UILabel!
    
    weak var delegate: DashboardHeaderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func configureCell(model:DashboardProfileCellModel) {
//        lblUserName.text = model.userName
//        btnSelectALocation.setTitle(model.location, for: .normal)
//        lblRating.text = "\(model.rating)/5"
    
    func configureCell() {

        if let userData = UserDefaults.standard.value(LoginModule.UserLogin.Response.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            let data = userData.data
            lblUserName.text = "\(data?.firstname ?? "") \(data?.lastname ?? "")"
            btnSelectALocation.setTitle(data?.base_salon_name ?? "", for: .normal)
            lblRating.text = "\(0.0)/5"
            lblDesignation.text = data?.designation ?? "-"
        }
    }
    
}

struct DashboardProfileCellModel{
    let userName: String
    let location: String
    let profilePictureURL: String
    let rating: Double
}
