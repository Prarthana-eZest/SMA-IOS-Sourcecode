//
//  RevenueViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RevenueDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class RevenueVC: UIViewController, RevenueDisplayLogic {
    var interactor: RevenueBusinessLogic?
    
    @IBOutlet weak private var tableView: UITableView!
    
    var revenues = [RevenueCellModel]()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = RevenueInteractor()
        let presenter = RevenuePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifier.revenueCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.revenueCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        showNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        getRevenueData()
    }
    
    func showNavigationBarButtons() {
        
        let revenueButton = UIBarButtonItem(title: "Revenue", style: .plain, target: self, action: #selector(didTapRevenueButton))
        revenueButton.tintColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
                
        navigationItem.title = ""
        navigationItem.leftBarButtonItems = [revenueButton]
    }

    
    @objc func didTapRevenueButton() {
    }
    
    func configureData(data: Revenue.OneClickData.Data) {
        
        revenues.removeAll()
        revenues.append(contentsOf: [
        RevenueCellModel(title: "Revenue multiplier", subTitle: "", value: "-"),
        
        RevenueCellModel(title: "YoY revenue growth", subTitle: "", value: "\(data.yoy_revenue_growth_services_and_product?.description.toDouble()?.cleanForPrice ?? "0")%"),
        
        RevenueCellModel(title: "Client consultation", subTitle: "From 50 Customer", value: "-"),
        
        RevenueCellModel(title: "Retail products", subTitle: "", value: "\(data.retail_products_as_percentage_to_services_revenue?.description.toDouble()?.cleanForPrice ?? "0")%"),
        
        RevenueCellModel(title: "Service revenue", subTitle: "", value: "\(data.total_service_revenue?.description.toDouble()?.cleanForPrice ?? "0")%"),
        
        RevenueCellModel(title: "Product revenue", subTitle: "", value: "\(data.total_products_revenue?.description.toDouble()?.cleanForPrice ?? "0")%"),

        
        RevenueCellModel(title: "Salon achievements", subTitle: "", value: "\(data.salon_achievement_percentage?.description.toDouble()?.cleanForPrice ?? "0")%"),
        
        RevenueCellModel(title: "RM consumption of category", subTitle: "", value: "-"),
        
        RevenueCellModel(title: "Quality", subTitle: "", value: "-"),
        
        RevenueCellModel(title: "Punctuality on appointments", subTitle: "", value: "-")])
        
        tableView.reloadData()
    }
}

extension RevenueVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.revenueCell, for: indexPath) as? RevenueCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: revenues[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
}

extension RevenueVC {
    
    func getRevenueData() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
            let salon_id = userData.salon_id {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = Revenue.OneClickData.Request(is_custom: true, salon_id: "\(salon_id)")
            interactor?.doGetOneClickRevenueData(request: request, method: .post)
        }
    }
    
    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")
        if let model = viewModel as? Revenue.OneClickData.Response, let data = model.data?.first {
            configureData(data: data)
        }
    }
    
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
}
