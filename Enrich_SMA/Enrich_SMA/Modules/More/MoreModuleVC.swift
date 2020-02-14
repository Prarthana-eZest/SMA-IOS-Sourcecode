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

    var userPunchedIn = false

    var profileDashboardIdentifiers: [ProfileCellIdentifiers] = [.punchIn,
                                                                 .myProfile,
                                                                 .employees,
                                                                // .inventory,
                                                                 //.stores,
                                                                 //.audits,
                                                                 .notifications,
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "")
    }
    // MARK: OpenLoginWindow
    //    func openLoginWindow() {
    //
    //        let vc = DoLoginPopUpVC.instantiate(fromAppStoryboard: .Location)
    //        vc.delegate = self
    //        self.view.alpha = screenPopUpAlpha
    //        self.appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
    //        vc.onDoneBlock = { [unowned self] result in
    //            // Do something
    //            if(result) {} else {}
    //            self.view.alpha = 1.0
    //        }
    //    }

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

        case .punchIn:

            let message = userPunchedIn ? AlertMessagesToAsk.askToPunchOut : AlertMessagesToAsk.askToPunchIn
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.yes, style: UIAlertAction.Style.cancel) { _ -> Void in
                self.userPunchedIn = !self.userPunchedIn
                self.tableView.reloadData()
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
//extension MoreModuleViewController: LoginRegisterDelegate {
//    func doLoginRegister() {
//        // Put your code here
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {[unowned self] in
//            let vc = LoginModuleVC.instantiate(fromAppStoryboard: .Main)
//            let navigationContrl = UINavigationController(rootViewController: vc)
//            self.present(navigationContrl, animated: true, completion: nil)
//        }
//    }
//}

// MARK: Call Webservice
extension MoreModuleVC {

    func doSomething() {
        let request = MoreModule.Something.Request(name: "TestData", salary: "100000", age: "10")
        interactor?.doPostRequest(request: request, method: HTTPMethod.post)
    }

    func displaySuccess<T: Decodable>(viewModel: T) {
        EZLoadingActivity.hide()
    }
    func displayError(errorMessage: String?) {
        DispatchQueue.main.async { [unowned self] in
            EZLoadingActivity.hide()
            self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
        }
    }

    func displaySuccess<T: Decodable>(responseSuccess: [T]) {
        DispatchQueue.main.async {
            EZLoadingActivity.hide()
            if let obj = responseSuccess as? [MoreModule.Something.Response] {
                print("Get API Response -- \n \(obj)")
            }
        }
    }

}
