//
//  AppointmentTimelineCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 07/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class AppointmentTimelineCell: UITableViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(model:AppointmentTimelineModel,isEndCell:Bool){
        lblTime.text = model.time
        lblTitle.text = model.title
        lblSubTitle.text = model.subTitle
        if !isEndCell{
            self.contentView.alpha =  model.alreadyCovered ? 1 : 0.5
            self.endView.isHidden = true
            self.roundView.isHidden = false
            self.lineView.backgroundColor = .lightGray
        }else{
            self.contentView.alpha = 1
            self.roundView.isHidden = true
            self.endView.isHidden = false
            self.lineView.backgroundColor = .clear
        }
    }
    
}

struct AppointmentTimelineModel {
    let time: String
    let title: String
    let subTitle: String
    let alreadyCovered: Bool
}
