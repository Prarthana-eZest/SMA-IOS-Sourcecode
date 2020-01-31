//
//  MyProfileHeaderCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 16/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit
import Kingfisher

class MyProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblDateOfJoining: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(model:MyProfileHeaderModel){
        lblUserName.text = model.userName
        lblSpeciality.text = model.speciality
        
        let dateString = model.dateOfJoining
        if let date = dateString.getDateFromString(){
            lblDateOfJoining.text = date.monthYearDate
        }else{
            lblDateOfJoining.text = dateString
        }
        
        
        let rating = Double(model.ratings)?.rounded(toPlaces: 1)
        if rating == 0{
            lblRatings.text = "0/5"
        }else{
            lblRatings.text = "\(rating ?? 0)/5"
        }
        
        ratingsView.isHidden = model.selfProfile
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height * 0.5
        let url = URL(string: model.profilePictureURL )
        profilePicture.kf.indicatorType = .activity
        let defaultImage = UIImage(named: "defaultProfile")
        if let imageurl = url{
            profilePicture.kf.setImage(with: imageurl, placeholder: defaultImage, options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            profilePicture.image = defaultImage
        }
    }
    
}

struct MyProfileHeaderModel{
    let profilePictureURL: String
    let userName: String
    let speciality: String
    let dateOfJoining: String
    let ratings: String
    let gender: String
    let selfProfile: Bool
}
