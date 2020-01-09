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

        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            lblUserName.text = "\(userData.firstname ?? "") \(userData.lastname ?? "")"
            btnSelectALocation.setTitle(userData.base_salon_name ?? "", for: .normal)
            let rating = userData.rating ?? 0
            if rating == 0{
                lblRating.text = "0/5"
            }else{
                lblRating.text = "\(rating)/5"
            }
            lblDesignation.text = userData.designation ?? "-"
            
            profilePicture.layer.cornerRadius = profilePicture.frame.size.height * 0.5
            let url = URL(string: userData.profile_pic ?? "" )
            profilePicture.kf.indicatorType = .activity
            let gender = userData.gender ?? "1"
            let defaultImage = (gender == "1" ? UIImage(named: "male-selected") : gender == "2" ? UIImage(named: "female-selected") : UIImage(named: "other-selected"))
            if let imageurl = url{
                profilePicture.kf.setImage(with: imageurl, placeholder: defaultImage, options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                profilePicture.image = defaultImage
            }
        }
    }
    
}

struct DashboardProfileCellModel{
    let userName: String
    let location: String
    let profilePictureURL: String
    let rating: Double
}
