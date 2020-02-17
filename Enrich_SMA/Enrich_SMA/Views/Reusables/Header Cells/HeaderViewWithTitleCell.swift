//
//  HeaderViewWithTitleCell.swift
//  EnrichSalon
//
//  Created by Harshal Patil on 04/07/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import UIKit

protocol HeaderDelegate: class {
    func actionViewAll(identifier: SectionIdentifier)
}

class HeaderViewWithTitleCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var viewAllButton: UIButton!

    weak var delegate: HeaderDelegate?
    var identifier: SectionIdentifier?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureHeader(title: String, hideViewAllButton: Bool) {
        titleLabel.text = title
        viewAllButton.isHidden = hideViewAllButton
    }

    @IBAction func actionViewAll(_ sender: Any) {
        if let identifier = identifier {
            self.delegate?.actionViewAll(identifier: identifier)
        }
    }

}
