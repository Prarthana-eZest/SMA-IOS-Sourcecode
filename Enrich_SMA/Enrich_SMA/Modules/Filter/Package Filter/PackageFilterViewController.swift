//
//  PackageFilterViewController.swift
//  Enrich_SMA
//
//  Created by Harshal on 27/01/22.
//  Copyright (c) 2022 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PackageFilterDisplayLogic: class
{
  func displaySomething(viewModel: PackageFilter.Something.ViewModel)
}

enum PackageType {
    static let value = "Value"
    static let service = "Service"
    static let product = "Product"
}

class PackageFilterViewController: UIViewController, PackageFilterDisplayLogic
{
    var interactor: PackageFilterBusinessLogic?
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var lblNoPackage: UILabel!
    @IBOutlet weak private var parentView: UIView!
    @IBOutlet var lblFilterTitle: UILabel!
    var data = [PackageFilterModel]()
    var filterType : String = ""
    var selectedPackage : String = ""
    var viewDismissBlock: ((Bool, String) -> Void)?

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
        let interactor = PackageFilterInteractor()
        let presenter = PackageFilterPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        tableView.register(UINib(nibName: CellIdentifier.packageFilterCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.packageFilterCell)
        tableView.separatorColor = .clear
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 8
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        getFilterData(filterType: filterType)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = PackageFilter.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: PackageFilter.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock?(true,"")
    }
    
    func getFilterData(filterType : String){
        let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
    
        data.append(PackageFilterModel(title: "All Packages", isSelected: (selectedPackage == ""), fromDate: nil, toDate: nil, sku: ""))
        
        
        if(filterType == "Service"){
        //service package
            lblFilterTitle.text = "SELECT SERVICE PACKAGE"
            
        let filterServicePackgeData = technicianDataJSON?.data?.filters?.packages?.Service?.filter({($0.package_type ?? "").containsIgnoringCase(find: PackageType.service)}) ?? []

        
        for objServicePackage in filterServicePackgeData {
            data.append(PackageFilterModel(title: objServicePackage.name ?? "", isSelected: (selectedPackage == objServicePackage.sku), fromDate: nil, toDate: nil, sku: objServicePackage.sku))
        }
        }
        
        else if(filterType == "Value"){
            
            lblFilterTitle.text = "SELECT VALUE PACKAGE"
            
            let filterValuePackageData = technicianDataJSON?.data?.filters?.packages?.Value?.filter({($0.package_type ?? "").containsIgnoringCase(find: PackageType.value)}) ?? []
           
            
            for objPackage in filterValuePackageData {
                data.append(PackageFilterModel(title: objPackage.name ?? "", isSelected: (selectedPackage == objPackage.sku), fromDate: nil, toDate: nil, sku: objPackage.sku))
        }
        }
        
        lblNoPackage.isHidden = !data.isEmpty
        tableView.reloadData()
        
    }
}

extension PackageFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.packageFilterCell, for: indexPath) as? PackageFilterCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: data[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
        data.forEach{$0.isSelected = false}
        data[indexPath.row].isSelected = true
        tableView.reloadData()
        let objData = data[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        if(data[indexPath.row].title == "All Packages"){
            viewDismissBlock?(true,"")
        }
        else {
            viewDismissBlock?(true,objData.sku)
        }
    }
}
