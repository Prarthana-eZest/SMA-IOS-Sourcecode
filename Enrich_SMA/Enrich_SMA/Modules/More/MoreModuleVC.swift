//
//  MoreModuleViewController.swift
//  EnrichSalon
//

import UIKit

enum ProfileCellIdentifiers: String {

    // Dashboard
    case punchIn = "Punch In"
    case punchOut = "Punch Out"
    case myProfile = "MyProfile"
    case employees = "Employees"
    case inventory = "Inventory"
    case stores = "Stores"
    case audits = "Audits"
    case notifications = "Notifications"
    case salonFeedback = "Salon Feedback"
    case logout = "Logout"

}

protocol MoreModuleDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
    func displaySuccess<T: Decodable>(responseSuccess: [T])
}

class MoreModuleVC: UIViewController, MoreModuleDisplayLogic {

    var interactor: MoreModuleBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var lblPunchInTime: UILabel!
    @IBOutlet weak private var lblPunchOutTime: UILabel!

    var userPunchedIn = false

    var profileDashboardIdentifiers: [ProfileCellIdentifiers] = [.punchIn,
                                                                 .myProfile,
                                                                 .employees,
                                                                // .inventory,
                                                                 //.stores,
                                                                 //.audits,
                                                                 .salonFeedback, .notifications,
                                                                 .logout]

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
        let interactor = MoreModuleInteractor()
        let presenter = MoreModulePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.doSomething()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)

        LocationManager.sharedInstance.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "")
        checkForSOSNotification()
        getCheckInStatus()
        getCheckInDetails()
    }

    func checkForSOSNotification() {
        SOSFactory.shared.getSOSNotification { (SOSAlert) in
            let vc = SOSAlertVC.instantiate(fromAppStoryboard: .Appointment)
            self.view.alpha = screenPopUpAlpha
            vc.alertData = SOSAlert; UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            vc.viewDismissBlock = { [unowned self] result in
                // Do something
                self.view.alpha = 1.0
                //self.checkForSOSNotification()
            }
        }
    }
}

extension MoreModuleVC: LocationManagerDelegate {

    func locationDidFound(_ latitude: Double, longitude: Double) {
        print("Location Latitude:\(latitude) Longitude:\(longitude)")
    }

}

extension MoreModuleVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDashboardIdentifiers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = profileDashboardIdentifiers[indexPath.row]

        var cell = UITableViewCell()
        if identifier == .notifications {
            guard let notificationCell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: ProfileCellIdentifiers.notifications.rawValue, for: indexPath) as? NotificationCell else {
                return cell
            }
            let title = "NOTIFICATION"
            notificationCell.configureCell(title: title, notificationCount: 12)
            notificationCell.updateConstraints()
            notificationCell.setNeedsDisplay()
            cell = notificationCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        else if identifier == .punchIn {
            let identifier = userPunchedIn ? ProfileCellIdentifiers.punchOut.rawValue : identifier.rawValue
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = profileDashboardIdentifiers[indexPath.row]
        print("Selection: \(identifier.rawValue)")

        switch identifier {

        case .myProfile:
            let vc = MyProfileVC.instantiate(fromAppStoryboard: .More)
            vc.profileType = .selfUser
            self.navigationController?.pushViewController(vc, animated: true)

        case .notifications :
            let vc = NotificationsVC.instantiate(fromAppStoryboard: .More)
            self.navigationController?.pushViewController(vc, animated: true)

        case .logout:
            let alertController = UIAlertController(title: alertTitle, message: AlertMessagesToAsk.askToLogout, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.yes, style: UIAlertAction.Style.cancel) { _ -> Void in
                UserFactory.shared.signOutUserFromApp()
            })
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.no, style: UIAlertAction.Style.default) { _ -> Void in
                // Do Nothing
            })
            self.present(alertController, animated: true, completion: nil)

        case .employees:
            let vc = EmployeeListingVC.instantiate(fromAppStoryboard: .More)
            self.navigationController?.pushViewController(vc, animated: true)

        case .inventory:
            break

        case .stores:
            break

        case .audits:
            break

        case .salonFeedback:
            let vc = AllReviewsVC.instantiate(fromAppStoryboard: .Appointment)
            vc.ratingType = .salon
            self.navigationController?.pushViewController(vc, animated: true)

        case .punchIn:

            let message = userPunchedIn ? AlertMessagesToAsk.askToPunchOut : AlertMessagesToAsk.askToPunchIn
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.yes, style: UIAlertAction.Style.cancel) { _ -> Void in
                self.markCheckInOut()
            })
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.no, style: UIAlertAction.Style.default) { _ -> Void in
            })
            self.present(alertController, animated: true, completion: nil)

        case .punchOut:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

}

// MARK: Call Webservice
extension MoreModuleVC {

    func getCheckInDetails() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = MoreModule.CheckInOutDetails.Request(date: Date().dayYearMonthDate, emp_code: userData.employee_code ?? "", is_custom: true)
            interactor?.doPostCheckInOutDetailsRequest(request: request, method: .post)
        }
    }

    func getCheckInStatus() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = MoreModule.GetCheckInStatus.Request(emp_code: userData.employee_code ?? "", date: Date().dayYearMonthDate, is_custom: true)
            interactor?.doPostGetStatusRequest(request: request, method: .post)
        }
    }

    func markCheckInOut() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {

            EZLoadingActivity.show("Loading...", disableUI: true)
            let lat = "\(LocationManager.sharedInstance.location().latitude)" // "22.997"
            let long = "\(LocationManager.sharedInstance.location().longitude)" // "72.608"

            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = MoreModule.MarkCheckInOut.Request(emp_code: userData.employee_code ?? "",
                                                            emp_name: userData.username ?? "",
                                                            branch_code: userData.base_salon_code ?? "",
                                                            checkinout_time: Date().checkInOutDateTime,
                                                            checkin: userPunchedIn ? "0" : "1",
                                                            employee_latitude: lat,
                employee_longitude: long, is_custom: true)

            interactor?.doPostMarkCheckInOutRequest(request: request, method: .post)
        }
    }

    func displaySuccess<T: Decodable>(viewModel: T) {
        EZLoadingActivity.hide()
        if let model = viewModel as? MoreModule.GetCheckInStatus.Response,
            model.status == true, let count = model.count {
            userPunchedIn = !(count % 2 == 0)
            self.tableView.reloadData()
        }
        else if let model = viewModel as? MoreModule.MarkCheckInOut.Response {

            if model.status == true {
                userPunchedIn = !userPunchedIn
                self.tableView.reloadData()
                getCheckInDetails()
            }
            DispatchQueue.main.async { [unowned self] in
                self.showAlert(alertTitle: alertTitle, alertMessage: model.message )
            }
        }
        else if let model = viewModel as? MoreModule.CheckInOutDetails.Response {
            if model.status == true {
                if let checkIn = model.data?.first(where: {$0.checkin == "1"}),
                    let dateTime = checkIn.checkinout_time,
                    let time = dateTime.getCheckInTime(dateString: dateTime, withFormat: "hh:mm aaa") {
                    lblPunchInTime.text = time
                }
                else {
                    lblPunchInTime.text = "-"
                }

                if let checkOut = model.data?.last(where: {$0.checkin == "0"}),
                    let dateTime = checkOut.checkinout_time,
                    let time = dateTime.getCheckInTime(dateString: dateTime, withFormat: "hh:mm aaa") {
                    lblPunchOutTime.text = time
                }
                else {
                    lblPunchOutTime.text = "-"
                }
            }
        }
    }
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        DispatchQueue.main.async { [unowned self] in
            self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
        }
    }

    func displaySuccess<T: Decodable>(responseSuccess: [T]) {
    }

}
