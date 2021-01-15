//
//  AppointmentFilterViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AppointmentFilterDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class AppointmentFilterVC: UIViewController, AppointmentFilterDisplayLogic {
    var interactor: AppointmentFilterBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var collectionView: UICollectionView!

    var technicianFilter = [TechnicianFilterModel]()
    var statusFilter = [StatusFilterModel]()

    var localTechnicianFilter = [TechnicianFilterModel]()
    var localStatusFilter = [StatusFilterModel]()

    var viewDismissBlock: ((Bool, [StatusFilterModel], [TechnicianFilterModel]) -> Void)?

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
        let interactor = AppointmentFilterInteractor()
        let presenter = AppointmentFilterPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if statusFilter.isEmpty {
            getFilterDetails()
        }
        else {
            localStatusFilter = statusFilter
            localTechnicianFilter = technicianFilter
            collectionView.reloadData()
            tableView.reloadData()
        }

        collectionView.register(UINib(nibName: CellIdentifier.statusFilterCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.statusFilterCell)
        tableView.register(UINib(nibName: CellIdentifier.checkBoxCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.checkBoxCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }

    // MARK: Do something

    func getFilterDetails() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = AppointmentFilter.GetFilterDetails.Request(
                salon_id: userData.salon_id, date: Date().dayYearMonthDate)
            interactor?.doGetFilterDetails(request: request)
        }
    }

    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock?(false, statusFilter, technicianFilter)
    }

    @IBAction func actionClearAll(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        for index in localStatusFilter.indices {
            localStatusFilter[index].isSelected = false
        }
        for index in localTechnicianFilter.indices {
            localTechnicianFilter[index].isSelected = false
        }
//        localStatusFilter.forEach {$0.isSelected = false}
//        localTechnicianFilter.forEach {$0.isSelected = false}
        statusFilter = localStatusFilter
        technicianFilter = localTechnicianFilter
        viewDismissBlock?(true, statusFilter, technicianFilter)
    }

    @IBAction func actionApply(_ sender: UIButton) {

        let status = localStatusFilter.filter {$0.isSelected}
        let technician = localTechnicianFilter.filter {$0.isSelected}
        if status.isEmpty && technician.isEmpty {
            self.showToast(alertTitle: alertTitle, message: AlertMessagesToAsk.filterValidation, seconds: toastMessageDuration)
            return
        }
        self.dismiss(animated: true, completion: nil)
        statusFilter = localStatusFilter
        technicianFilter = localTechnicianFilter
        viewDismissBlock?(true, statusFilter, technicianFilter)
    }

}

extension AppointmentFilterVC {

    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")

        if let model = viewModel as? AppointmentFilter.GetFilterDetails.Response {
            print("Model: \(model)")

            self.localStatusFilter.removeAll()
            model.data?.status_list?.forEach {
                self.localStatusFilter.append(StatusFilterModel(status: $0, isSelected: false))
            }
            self.collectionView.reloadData()

            self.localTechnicianFilter.removeAll()
            model.data?.technician_list?.forEach {
                self.localTechnicianFilter.append(TechnicianFilterModel(name: $0.name ?? "", id: $0.id ?? 0, isSelected: false))
            }
            self.tableView.reloadData()
        }
    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension AppointmentFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localStatusFilter.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.statusFilterCell, for: indexPath) as? StatusFilterCell else {
            return UICollectionViewCell()
        }
        let status = localStatusFilter[indexPath.row]
        cell.configureCell(status: status.status ?? "", isSelected: status.isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        localStatusFilter[indexPath.row].isSelected = !localStatusFilter[indexPath.row].isSelected
        collectionView.reloadData()
    }
}

extension AppointmentFilterVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localTechnicianFilter.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.checkBoxCell, for: indexPath) as? CheckBoxCell else {
            return UITableViewCell()
        }

        cell.configureCell(model: localTechnicianFilter[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
        localTechnicianFilter[indexPath.row].isSelected = !localTechnicianFilter[indexPath.row].isSelected
        tableView.reloadData()
    }
}
