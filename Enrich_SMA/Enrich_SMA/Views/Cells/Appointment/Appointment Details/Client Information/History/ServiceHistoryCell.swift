//
//  ServiceHistoryCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit
import Cosmos

protocol ClientInformationDelegate: class {
    func actionOtherServices(indexPath: IndexPath)
}

class ServiceHistoryCell: UITableViewCell {

    @IBOutlet private weak var lblDateTime: UILabel!
    @IBOutlet private weak var lblServiceStatus: UILabel!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblServiceName: UILabel!
    @IBOutlet private weak var btnOtherServicesCount: UIButton!
    @IBOutlet private weak var ratingsView: CosmosView!
    @IBOutlet private weak var stackViewServiceCount: UIStackView!

    var indexPath: IndexPath?
    weak var delegate: ClientInformationDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingsView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: ClientInformation.GetAppointnentHistory.Data) {

        if let dateString = model.appointment_date,
            let date = dateString.getDateFromString() {
            lblDateTime.text = date.dayNameDateFormat
        } else {
            lblDateTime.text = ""
        }

        lblServiceStatus.text = model.status ?? ""
        lblUserName.text = model.booked_by ?? ""
        lblServiceName.text = model.services?.first?.service_name ?? "Not available"
        btnOtherServicesCount.setTitle("+\((model.services?.count ?? 1) - 1)", for: .normal)
        ratingsView.rating = model.avg_rating ?? 0.0
        stackViewServiceCount.isHidden = ((model.services?.count ?? 1) < 2)
    }

    @IBAction func actionOtherServices(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.actionOtherServices(indexPath: indexPath)
        }
    }

}
