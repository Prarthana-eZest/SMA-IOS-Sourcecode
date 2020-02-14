//
//  YourTargetRevenueCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

protocol TargetRevenueDelegate: class {
    func actionDaily()
    func actionMonthly()
    func actionViewAll()
    func actionMoreInfo()
}

class YourTargetRevenueCell: UITableViewCell {

    // Service Revenue
    @IBOutlet weak private var lblServiceRevenuePercent: UILabel!
    @IBOutlet weak private var serviceRevenueProgressBar: UIProgressView!
    @IBOutlet weak private var lblServiceRevenueAmount: UILabel!

    // Product Revenue
    @IBOutlet weak private var lblProductRevenuePercent: UILabel!
    @IBOutlet weak private var productRevenueProgressBar: UIProgressView!
    @IBOutlet weak private var lblProductRevenueAmount: UILabel!

    // Membership Sold
    @IBOutlet weak private var lblMembershipPercent: UILabel!
    @IBOutlet weak private var membershipProgressBar: UIProgressView!
    @IBOutlet weak private var lblMembershipAmount: UILabel!

    @IBOutlet weak private var btnDaily: UIButton!
    @IBOutlet weak private var btnMonthly: UIButton!

    @IBOutlet weak private var dailySelectionView: UIView!
    @IBOutlet weak private var monthlySelectionView: UIView!

    // Amount
    @IBOutlet weak private var lblTotalCash: UILabel!
    @IBOutlet weak private var lblTotalSales: UILabel!
    @IBOutlet weak private var lblTotalRevenue: UILabel!
    @IBOutlet weak private var lblSalesModified: UILabel!

    weak var delegate: TargetRevenueDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        serviceRevenueProgressBar.layer.cornerRadius = 7
        serviceRevenueProgressBar.layer.masksToBounds = true

        productRevenueProgressBar.layer.cornerRadius = 7
        productRevenueProgressBar.layer.masksToBounds = true

        membershipProgressBar.layer.cornerRadius = 7
        membershipProgressBar.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionMoreInfo(_ sender: UIButton) {
        delegate?.actionMoreInfo()
    }

    @IBAction func actionDaily(_ sender: UIButton) {
        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnDaily.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnMonthly.titleLabel?.font = font
        }
        dailySelectionView.isHidden = false
        monthlySelectionView.isHidden = true

        delegate?.actionDaily()
    }

    @IBAction func actionMonthly(_ sender: UIButton) {
        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnMonthly.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnDaily.titleLabel?.font = font
        }
        dailySelectionView.isHidden = true
        monthlySelectionView.isHidden = false

        delegate?.actionMonthly()
    }

}
