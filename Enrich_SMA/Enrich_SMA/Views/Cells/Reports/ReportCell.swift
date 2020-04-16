//
//  ReportCell.swift
//  
//
//  Created by Harshal on 16/04/20.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak private var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(title: String) {
        lblTitle.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
