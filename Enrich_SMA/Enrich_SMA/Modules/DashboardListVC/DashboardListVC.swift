//
//  DashboardListVC.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 13/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit

class DashboardListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: CellIdentifier.dashboardTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.dashboardTableViewCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Back")        
    }
    
}

extension DashboardListVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.dashboardTableViewCell) as! DashboardTableViewCell
        cell.selectionStyle = .none
        cell.configureSection(currentIndex: indexPath.row, income: 50000.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
