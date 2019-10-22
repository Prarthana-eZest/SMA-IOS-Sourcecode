//
//  DashboardViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DashboardDisplayLogic: class
{
    func displaySomething(viewModel: Dashboard.Something.ViewModel)
}

class DashboardVC: UIViewController, DashboardDisplayLogic
{
    var interactor: DashboardBusinessLogic?
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //    if let scene = segue.identifier {
        //      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //      if let router = router, router.responds(to: selector) {
        //        router.perform(selector, with: segue)
        //      }
        //    }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        tableView.register(UINib(nibName: "DashboardProfileCell", bundle: nil), forCellReuseIdentifier: "DashboardProfileCell")
        tableView.register(UINib(nibName: "TodaysAppointmentHeaderCell", bundle: nil), forCellReuseIdentifier: "TodaysAppointmentHeaderCell")
        tableView.register(UINib(nibName: "YourTargetRevenueCell", bundle: nil), forCellReuseIdentifier: "YourTargetRevenueCell")
        tableView.register(UINib(nibName: "AppointmentStatusCell", bundle: nil), forCellReuseIdentifier: "AppointmentStatusCell")
        
        tableView.contentInset =  UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = Dashboard.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Dashboard.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}

extension DashboardVC:AppointmentDelegate{
    
    func actionViewAll() {
        print("View All")
    }
    
    func actionDelete(indexPath: IndexPath) {
        print("Delete:\(indexPath.row)")
    }
    
    func actionModify(indexPath: IndexPath) {
        print("Modify:\(indexPath.row)")
    }
}

extension DashboardVC:TargetRevenueDelegate{
    
    func actionDaily() {
        print("Daily")
    }
    
    func actionMonthly() {
        print("Monthly")
    }
    
}
    

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardProfileCell", for: indexPath) as? DashboardProfileCell else {
                return UITableViewCell()
            }
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysAppointmentHeaderCell", for: indexPath) as? TodaysAppointmentHeaderCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentStatusCell", for: indexPath) as? AppointmentStatusCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourTargetRevenueCell", for: indexPath) as? YourTargetRevenueCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
}
