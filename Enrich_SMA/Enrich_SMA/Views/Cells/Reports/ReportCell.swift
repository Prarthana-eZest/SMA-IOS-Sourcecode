//
//  ReportCell.swift
//  
//
//  Created by Harshal on 16/04/20.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var dropDownIcon: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(title: String, isHeader: Bool, isSelected: Bool) {
        if isHeader {
            if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 18) {
                lblTitle.font = font
            }
            lblTitle.text = title
        }
        else {
            if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
                lblTitle.font = font
            }
            lblTitle.text = "  - \(title)"
        }
        dropDownIcon.isHidden = !isHeader
        dropDownIcon.isSelected = isSelected
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
