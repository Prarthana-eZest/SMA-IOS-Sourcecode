//
//  StatusFilterCell.swift
//  Enrich_SMA
//
//  Created by Harshal on 15/01/21.
//  Copyright © 2021 e-zest. All rights reserved.
//

import UIKit

class StatusFilterCell: UICollectionViewCell {

    @IBOutlet weak private var borderView: UIView!
    @IBOutlet weak private var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(status: String, isSelected: Bool) {
        borderView.layer.cornerRadius = 6
        borderView.layer.masksToBounds = true
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 1
        lblStatus.text = status

        if isSelected {
            if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 16) {
                lblStatus.font = font
                borderView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
                lblStatus.textColor = UIColor.white
            }
        }
        else {
            if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
                lblStatus.font = font
                lblStatus.textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
                borderView.backgroundColor = UIColor.white
            }
        }
    }
}
