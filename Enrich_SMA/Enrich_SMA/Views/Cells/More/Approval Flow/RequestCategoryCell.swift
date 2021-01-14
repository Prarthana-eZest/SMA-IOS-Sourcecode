//
//  RequestCategoryCell.swift
//  Enrich_SMA
//
//  Created by Harshal on 05/05/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class RequestCategoryCell: UITableViewCell {

    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblStartTime: UILabel!
    @IBOutlet weak private var lblEndTime: UILabel!
    @IBOutlet weak private var lblPrice: UILabel!
    @IBOutlet weak private var lblDuration: UILabel!
    @IBOutlet weak private var priceStackView: UIStackView!
    @IBOutlet weak private var lblCustomerName: UILabel!
    @IBOutlet weak private var lblTechnicianName: UILabel!
    
    @IBOutlet weak private var customerStackView: UIStackView!
    @IBOutlet weak private var technicianStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: RequestCategoryModel) {
        lblTitle.text = model.title ?? ""
        lblStartTime.text = model.startTime ?? ""
        lblEndTime.text = model.endTime ?? ""
        let price = model.price?.toDouble()?.cleanForPrice ?? "0"
        lblPrice.text =  "₹\(price)"
        priceStackView.isHidden = model.price == nil
        lblDuration.text = "\(model.duration ?? "0") min"
        lblCustomerName.text = model.customerName ?? ""
        customerStackView.isHidden = model.customerName == nil
        lblTechnicianName.text = model.servicing_technician ?? ""
        technicianStackView.isHidden = model.servicing_technician == nil
    }
}

struct RequestCategoryModel {
    let title: String?
    let startTime: String?
    let endTime: String?
    let price: String?
    let duration: String?
    let customerName: String?
    let servicing_technician: String?
}
