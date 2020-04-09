//
//  ReviewThumpsUpDownCell.swift
//  EnrichSalon
//
//  Created by Apple on 28/06/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import UIKit

class UserRatingCell: UITableViewCell {

    @IBOutlet weak private var lblRating: UILabel!
    @IBOutlet weak private var lblCustomerComments: UILabel!
    @IBOutlet weak private var lblcustomerName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: RatingModel) {
        lblRating.text = "\(model.rating.toDouble()?.cleanForRating ?? "0")/5"
        lblCustomerComments.text = model.comment
        lblcustomerName.text = "\(model.customerNane) | \(model.date)"
    }

}

struct RatingModel {
    let rating: String
    let customerNane: String
    let comment: String
    let date: String
}
