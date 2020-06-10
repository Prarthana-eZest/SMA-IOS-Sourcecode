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

protocol DashboardDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class DashboardVC: UIViewController, DashboardDisplayLogic {
    var interactor: DashboardBusinessLogic?
    @IBOutlet weak private var tableView: UITableView!

    var sections = [SectionConfiguration]()

    var dailyData: Dashboard.GetDashboardData.revenueData?
    var monthlyData: Dashboard.GetDashboardData.revenueData?

    var selectedRevenueIndex = 0 // 0: Daily , 1:Monthy

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
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    if let scene = segue.identifier {
        //      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //      if let router = router, router.responds(to: selector) {
        //        router.perform(selector, with: segue)
        //      }
        //    }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifier.dashboardProfileCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.dashboardProfileCell)
        tableView.register(UINib(nibName: CellIdentifier.yourTargetRevenueCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.yourTargetRevenueCell)

        tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        getProfileData()
    }

    func configureSections() {
        sections.removeAll()
        sections.append(configureSection(idetifier: .dashboardProfile, items: 1, data: []))
        sections.append(configureSection(idetifier: .targetRevenue, items: 1, data: []))
        tableView.reloadData()
        print("Reload tableview")
    }

    func checkForSOSNotification() {
        SOSFactory.shared.getSOSNotification { (SOSAlert) in
            let vc = SOSAlertVC.instantiate(fromAppStoryboard: .Appointment)
            self.view.alpha = screenPopUpAlpha
            vc.alertData = SOSAlert
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            vc.viewDismissBlock = { [unowned self] result in
                // Do something
                self.view.alpha = 1.0
                //self.checkForSOSNotification()
            }
        }
    }

    func showAppUpdateAlert(response: Dashboard.GetForceUpadateInfo.Response) {

        if let appInfo = response.data?.force_update_info, let iOSAppInfo = appInfo.sma_ios, let forceUpdate = iOSAppInfo.force_update, let appVersion = iOSAppInfo.latest_version {
            if appVersion != Bundle.main.versionNumber {
                if forceUpdate {
                    alertForAppUpdate(
                        alertTitle: alertTitle,
                        messageTo: AlertMessagesSuccess.newAppVersion,
                        buttonTitleYes: AlertButtonTitle.update,
                        buttonTitleNo: AlertButtonTitle.updateNotNow,
                        isForceUpdate: forceUpdate,
                        newAppLink: iOSAppInfo.app_link ?? "")

                }
                else // Not Force Update
                {
                    if let notNowDate = UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_ForceUpdateNotNow) as? Date {

                        if notNowDate < Date() {
                            UserDefaults.standard.removeObject(forKey: UserDefauiltsKeys.k_key_ForceUpdateNotNow)
                            alertForAppUpdate(
                                alertTitle: alertTitle,
                                messageTo: AlertMessagesSuccess.newAppVersion,
                                buttonTitleYes: AlertButtonTitle.update,
                                buttonTitleNo: AlertButtonTitle.updateNotNow,
                                isForceUpdate: forceUpdate,
                                newAppLink: iOSAppInfo.app_link ?? "")
                        }

                    }
                    else {
                        alertForAppUpdate(
                            alertTitle: alertTitle,
                            messageTo: AlertMessagesSuccess.newAppVersion,
                            buttonTitleYes: AlertButtonTitle.update,
                            buttonTitleNo: AlertButtonTitle.updateNotNow,
                            isForceUpdate: forceUpdate,
                            newAppLink: iOSAppInfo.app_link ?? "")

                    }

                }
            }
        }

    }
}

extension DashboardVC {

    func getProfileData() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        interactor?.doGetMyProfileData(accessToken: self.getAccessToken(), method: .get)
    }

    func getForceUpadateInfo() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        interactor?.doGetForceUpdateInfo()
    }

    func getDashboardData() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
            let salon_id = userData.salon_id {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = Dashboard.GetDashboardData.Request(is_custom: true, salon_id: salon_id)
            interactor?.doGetDashboardData(request: request, method: .post)
        }
    }

    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")

        if let model = viewModel as? MyProfile.GetUserProfile.Response, model.status == true {
            if let data = model.data {
                let userDefaults = UserDefaults.standard
                userDefaults.set(encodable: data, forKey: UserDefauiltsKeys.k_Key_LoginUser)
                userDefaults.synchronize()
                getForceUpadateInfo()
                getDashboardData()
                checkForSOSNotification()
                FirebaseTopicFactory.shared.firebaseTopicSubscribe(employeeId: data.employee_id ?? "", salonId: data.salon_id ?? "")
                configureSections()
            }
        }
        else if let model = viewModel as? Dashboard.GetDashboardData.Response {
            if model.status == true {
                dailyData = model.data?.daily_revenue_data?.first
                monthlyData = model.data?.monthly_revenue_data?.first
                configureSections()
            }
            else {
                showAlert(alertTitle: alertTitle, alertMessage: model.message)
            }
        }
        else if let model = viewModel as? Dashboard.GetForceUpadateInfo.Response {
            if model.status == true {
                showAppUpdateAlert(response: model)
            }
            else {
                showAlert(alertTitle: alertTitle, alertMessage: model.message)
            }
        }
    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
}

extension DashboardVC: AppointmentDelegate {

    func actionRatings(indexPath: IndexPath) {
        print("Ratings")
    }

    func actionViewAll() {
        print("View All")
    }

    func actionMoreInfo() {
        print("More Info")
        let vc = RevenueVC.instantiate(fromAppStoryboard: .Dashboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func actionDelete(indexPath: IndexPath) {
        print("Delete:\(indexPath.row)")
    }

    func actionModify(indexPath: IndexPath) {
        print("Modify:\(indexPath.row)")
    }

    func servicesAction(indexPath: IndexPath) {
    }
}

extension DashboardVC: TargetRevenueDelegate {

    func actionDaily() {
        print("Daily")
        selectedRevenueIndex = 0
        tableView.reloadData()
    }

    func actionMonthly() {
        print("Monthly")
        selectedRevenueIndex = 1
        tableView.reloadData()
    }

}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = sections[indexPath.section]

        switch data.identifier {

        case .dashboardProfile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.dashboardProfileCell, for: indexPath) as? DashboardProfileCell else {
                return UITableViewCell()
            }
            cell.configureCell()
            cell.selectionStyle = .none
            return cell

        case .targetRevenue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.yourTargetRevenueCell, for: indexPath) as? YourTargetRevenueCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureCell(selectedIndex: selectedRevenueIndex, data: selectedRevenueIndex == 0 ? dailyData : monthlyData)
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
        let data = sections[indexPath.section]

        switch data.identifier {
        case .dashboardProfile:
            let vc = MyProfileVC.instantiate(fromAppStoryboard: .More)
            vc.profileType = .selfUser
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }
}

extension DashboardVC {

    func configureSection(idetifier: SectionIdentifier, items: Int, data: Any) -> SectionConfiguration {

        let headerHeight: CGFloat = 60
        let cellWidth: CGFloat = (tableView.frame.size.width - 40)
        let cellHeight: CGFloat = 320
        let margin: CGFloat = 20

        switch idetifier {

        case .dashboardProfile:

            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight, cellWidth: cellWidth,
                                        showHeader: true, showFooter: false, headerHeight: headerHeight, footerHeight: 0,
                                        leftMargin: margin, rightMarging: 0, isPagingEnabled: false,
                                        textFont: nil, textColor: .black, items: items, identifier: idetifier, data: data)

        case .targetRevenue:

            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight, cellWidth: cellWidth,
                                        showHeader: false, showFooter: false, headerHeight: 0, footerHeight: 0,
                                        leftMargin: 0, rightMarging: 0, isPagingEnabled: false,
                                        textFont: nil, textColor: .black, items: items, identifier: idetifier, data: data)

        default :
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: 0, cellWidth: cellWidth,
                                        showHeader: false, showFooter: false, headerHeight: headerHeight, footerHeight: 0,
                                        leftMargin: 0, rightMarging: 0, isPagingEnabled: false,
                                        textFont: nil, textColor: .black, items: items, identifier: idetifier, data: data)
        }
    }
}
