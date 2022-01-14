//
//  CTCDetailsCollectionViewCell.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 14/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit

class CTCDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.parentView.dropShadow()
    }

}
