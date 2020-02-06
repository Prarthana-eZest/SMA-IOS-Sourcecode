//
//  ListingVC.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class ListingVC: UIViewController {

    var screenTitle = ""
    var listing = [String]()
    var services = [ServiceListingModel]()

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoRecords: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewDismissBlock: ((Bool) -> Void)?

    var listingType: ListingType = .services

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = listingType.rawValue
        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
        tableView.register(UINib(nibName: CellIdentifier.serviceListingCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.serviceListingCell)

    }

    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock?(true)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

extension ListingVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listingType == .appointmentServices {
            lblNoRecords.isHidden = !services.isEmpty
            return services.count
        } else {
            lblNoRecords.isHidden = !listing.isEmpty
            return listing.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if listingType == .appointmentServices {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.serviceListingCell, for: indexPath) as? ServiceListingCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            cell.configureCell(model: services[indexPath.row])
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listingCell, for: indexPath) as? ListingCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            if listingType == .services {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            }
            else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
            }
            cell.configureCell(text: listing[indexPath.row])
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listingType == .shifts {
            return 55
        }
        else if  listingType == .services {
            return 40
        }
        return UITableView.automaticDimension
    }
}
