//
//  DashboardGridCollectionViewCell.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 14/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit

class DashboardGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var dashViewImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblRupeeSymbol: UILabel!
    @IBOutlet private weak var stackViewsubTitleContainer: UIStackView!
    
    let gradientLayer = CAGradientLayer()
    
    var firstColorCodeArray:[String] = ["#349790", "#2976C4", "#E83B70", "#FF8C27", "#8A2ADE", "#448B09", "#B054BB", "#385B64"]
    var secondColorCodeArray: [String] = ["#90D6B5", "#8FE4F2", "#FFE0B1", "#FFDCC5", "#AFA5FF", "#A3D346","#FF77A6", "#CBF0FF"]
    
    var dashViewImageArray = ["Revenue", "Sales", "FreeServices", "Footfall", "CustomerEngagement", "Productivity", "PenetrationRatios", "ResourceUtilisation"]
    var titleArray = ["Revenue", "Sales", "Free Services", "Footfall", "Customer Engagement", "Productivity", "Penetration Ratios", "Resource Utilisation"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureSection(currentIndex:Int, income:Double){
        
        self.dashViewImageView.image = UIImage(named: self.dashViewImageArray[currentIndex])
        self.lblTitle.text = self.titleArray[currentIndex]
        if 4...7 ~= currentIndex {
            self.stackViewsubTitleContainer.isHidden = true
        } else {
            self.stackViewsubTitleContainer.isHidden = false
            self.lblSubTitle.isHidden = false
            if(income == 0.0)
            {
                self.stackViewsubTitleContainer.isHidden = true
            }
            else {
                self.stackViewsubTitleContainer.isHidden = false
                if(currentIndex == 2 || currentIndex == 3)
                {
                    lblRupeeSymbol.isHidden = true
                }
                else {
                    lblRupeeSymbol.isHidden = false
                }
            self.lblSubTitle.text = income.roundedStringValue()
            }
        }
        gradientLayer.colors = [UIColor(hexString: firstColorCodeArray[currentIndex]).cgColor, UIColor(hexString: secondColorCodeArray[currentIndex]).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        //gradientLayer.frame = self.parentView.frame
        self.parentView.layer.cornerRadius = 10
        gradientLayer.cornerRadius = self.parentView.layer.cornerRadius
        gradientLayer.masksToBounds = true
        self.parentView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
}
