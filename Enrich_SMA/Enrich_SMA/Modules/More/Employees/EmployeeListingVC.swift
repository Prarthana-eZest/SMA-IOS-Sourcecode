//
//  EmployeeListingViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EmployeeListingDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

enum AvailableStatusColor: String {

    case onTime = "on_time"
    case delayed = "delayed"
    case notCheckedIn = "not_checked_in"
    case leave = "leave"
    case checkedIn = "checked_in"
    case unknown = "unknown"

    var status: String {
        switch self {

        case .onTime:
            return "On Time"
        case .checkedIn:
            return "Checked In"
        case .delayed:
            return "Delayed"
        case .notCheckedIn:
            return "Not Checked In"
        case .leave:
            return "On Leave"

        default:
            return ""
        }
    }

    var color: UIColor {

        switch self {

        case .onTime, .checkedIn:
            return UIColor(red: 70 / 255, green: 196 / 255, blue: 91 / 255, alpha: 1)
        case .delayed:
            return UIColor(red: 238 / 255, green: 91 / 255, blue: 70 / 255, alpha: 1)
        case .notCheckedIn:
            return UIColor(red: 83 / 255, green: 83 / 255, blue: 83 / 255, alpha: 1)
        case .leave:
            return UIColor(red: 83 / 255, green: 83 / 255, blue: 83 / 255, alpha: 1)

        default:
            return UIColor(red: 83 / 255, green: 83 / 255, blue: 83 / 255, alpha: 1)
        }
    }
}

class EmployeeListingVC: UIViewController, EmployeeListingDisplayLogic {
    var interactor: EmployeeListingBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var lblNoRecords: UILabel!

    var employeeList = [EmployeeModel]()

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
        let interactor = EmployeeListingInteractor()
        let presenter = EmployeeListingPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            if let router = router, router.responds(to: selector) {
        //                router.perform(selector, with: segue)
        //            }
        //        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployeeList()
        tableView.register(UINib(nibName: CellIdentifier.employeeCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.employeeCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
        lblNoRecords.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Employees")
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func getEmployeeList() {
        let todaysDate = Date().dayYearMonthDate
        EZLoadingActivity.show("Loading...", disableUI: true)

        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {

            let request = EmployeeListing.GetEmployeeList.Request(salon_code: userData.base_salon_code ?? "", fromDate: todaysDate, toDate: todaysDate )
            interactor?.doGetEmployeeListData(request: request, method: HTTPMethod.get)
        }

    }

    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")
        if let model = viewModel as? EmployeeListing.GetEmployeeList.Response, model.status == true {
            if let data = model.data, data.isEmpty {
                showAlert(alertTitle: alertTitle, alertMessage: model.message)
                return
            }
            modelMapping(response: model)
        }
    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }

    func modelMapping(response: EmployeeListing.GetEmployeeList.Response) {
        self.employeeList.removeAll()
        response.data?.forEach {

            if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
                let employeeId = $0.employee_id,
                let loginUserId = userData.employee_id,
                String(employeeId) != loginUserId {

                var statusType: AvailableStatusColor = AvailableStatusColor.leave
                var statusText = ""

                if $0.is_leave == 1 {
                    statusText = $0.leave_type ?? ""
                }
                else if let status = AvailableStatusColor(rawValue: $0.attendance_status ?? "") {
                    statusType = status
                    statusText = status.status
                }
                else {
                    statusText = $0.attendance_status ?? ""
                }

                let model = EmployeeModel(name: "\($0.first_name ?? "") \($0.last_name ?? "")", level: $0.designation ?? "",
                                          ratings: $0.rating ?? 0, statusType: statusType, statusText: statusText,
                                          employeeId: $0.employee_id)
                self.employeeList.append(model)
            }
        }
        lblNoRecords.isHidden = !employeeList.isEmpty
        self.tableView.reloadData()
    }

}

extension EmployeeListingVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.employeeCell, for: indexPath) as? EmployeeCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: employeeList[indexPath.row])
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
        let vc = MyProfileVC.instantiate(fromAppStoryboard: .More)
        vc.profileType = .otherUser
        vc.employeeId = employeeList[indexPath.row].employeeId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
