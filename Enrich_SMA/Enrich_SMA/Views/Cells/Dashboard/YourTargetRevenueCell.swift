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

    @IBOutlet weak private var lblRunRate: UILabel!

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

    func configureCell(selectedIndex: Int, data: Dashboard.GetDashboardData.revenueData?) {

        configureView(selectedIndex: selectedIndex)

        lblRunRate.text = "Required Run Rate: \(data?.runrate_percentage?.description.toDouble()?.cleanForPrice ?? "0")%"

        // Cash Details
        lblTotalCash.text = "₹ \(data?.total_collection?.description.toDouble()?.cleanForPrice ?? "0")"
        lblTotalSales.text = "₹ \(data?.total_gross_sales?.description.toDouble()?.cleanForPrice ?? "0")"
        lblTotalRevenue.text = "₹ \(data?.total_gross_revenue?.description.toDouble()?.cleanForPrice ?? "0")"
        lblSalesModified.text = "₹ \(data?.sales_modified?.description.toDouble()?.cleanForPrice ?? "0")"

        lblSalesModified.text = "₹ \(data?.sales_modified?.description.toDouble()?.cleanForPrice ?? "0")"

        // Service
        let servicePercent = data?.service_revenue_percentage?.description.toDouble() ?? 0
        let serviceRevenue = data?.service_revenue?.description.toDouble()?.cleanForPrice ?? "0"
        let serviceTarget = data?.service_target?.description.toDouble()?.cleanForPrice ?? "0"

        lblServiceRevenuePercent.text = "\(servicePercent.cleanForPrice)%"
        lblServiceRevenueAmount.text = "\(serviceRevenue)/\(serviceTarget)"
        serviceRevenueProgressBar.progress = Float(servicePercent)

        // Products
        let productPercent = data?.products_revenue_percentage?.description.toDouble() ?? 0
        let productRevenue = data?.products_revenue?.description.toDouble()?.cleanForPrice ?? "0"
        let productTarget = data?.products_target?.description.toDouble()?.cleanForPrice ?? "0"

        lblProductRevenuePercent.text = "\(productPercent.cleanForPrice)%"
        lblProductRevenueAmount.text = "\(productRevenue)/\(productTarget)"
        productRevenueProgressBar.progress = Float(productPercent)

        // Membership
        let membershipPercent = data?.membership_sold_percentage?.description.toDouble() ?? 0
        let membershipRevenue = data?.membership_revenue?.description.toDouble()?.cleanForPrice ?? "0"
        let membershipTarget = data?.membership_target?.description.toDouble()?.cleanForPrice ?? "0"

        lblMembershipPercent.text = "\(membershipPercent.cleanForPrice)%"
        lblMembershipAmount.text = "\(membershipRevenue)/\(membershipTarget)"
        membershipProgressBar.progress = Float(membershipPercent)

    }

    @IBAction func actionMoreInfo(_ sender: UIButton) {
        delegate?.actionMoreInfo()
    }

    @IBAction func actionDaily(_ sender: UIButton) {
        delegate?.actionDaily()
    }

    @IBAction func actionMonthly(_ sender: UIButton) {
        delegate?.actionMonthly()
    }

    func configureView(selectedIndex: Int) {

        if selectedIndex == 0 {
            if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 16) {
                btnDaily.titleLabel?.font = font
            }
            if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
                btnMonthly.titleLabel?.font = font
            }
            dailySelectionView.isHidden = false
            monthlySelectionView.isHidden = true
        }
        else {
            if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 16) {
                btnMonthly.titleLabel?.font = font
            }
            if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
                btnDaily.titleLabel?.font = font
            }
            dailySelectionView.isHidden = true
            monthlySelectionView.isHidden = false
        }
    }

}
