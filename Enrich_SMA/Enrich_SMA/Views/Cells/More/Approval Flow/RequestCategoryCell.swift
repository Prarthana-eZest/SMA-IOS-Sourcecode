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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: RequestCategoryModel) {
        lblTitle.text = model.title ?? ""
        lblStartTime.text = model.startTime ?? ""
        lblEndTime.text = model.endTime ?? ""
        lblPrice.text = "₹\(model.price ?? "0")"
        lblDuration.text = "\(model.duration ?? "0") min"
    }
}

struct RequestCategoryModel {
    let title: String?
    let startTime: String?
    let endTime: String?
    let price: String?
    let duration: String?
}
