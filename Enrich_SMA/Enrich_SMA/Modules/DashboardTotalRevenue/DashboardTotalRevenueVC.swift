//
//  DashboardTotalRevenueVC.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 14/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit

class DashboardTotalRevenueVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parentView: UIView!
    var firstColorCode:String = "#349790"
    var secondColorCode:String = "#90D6B5"
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.colors = [UIColor(hexString: self.firstColorCode).cgColor, UIColor(hexString: secondColorCode).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.parentView.frame
        self.parentView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.parentView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
        gradientLayer.masksToBounds = true
        self.parentView.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: "Back")
    }
    
}
