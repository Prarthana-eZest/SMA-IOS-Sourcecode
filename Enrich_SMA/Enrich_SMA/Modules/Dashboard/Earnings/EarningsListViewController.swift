//
//  EarningsListViewController.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 14/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit

class EarningsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: CellIdentifier.dashboardTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.dashboardTableViewCell)
        self.tableView.register(UINib(nibName: CellIdentifier.viewCTCDeatilsCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.viewCTCDeatilsCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Back")
        addFilterButtonOnRight(imageName: "filterIcon")
        
    }
    
}

extension EarningsListViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 8{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.viewCTCDeatilsCell) as! ViewCTCDeatilsCell
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.dashboardTableViewCell) as! DashboardTableViewCell
            cell.selectionStyle = .none
            cell.configureSection(currentIndex: indexPath.row, income: 50000.0)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 8{
            return 90
        }
        return 110
    }
    
}
