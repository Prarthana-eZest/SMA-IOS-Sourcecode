//
//  NotificationsViewController.swift
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

protocol NotificationsDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class NotificationsVC: UIViewController, NotificationsDisplayLogic {
    var interactor: NotificationsBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var cartCountView: UIView!
    @IBOutlet weak private var lblMyCartCount: UILabel!
    @IBOutlet weak private var btnBack: UIButton!
    @IBOutlet weak private var lblBackTitle: LabelButton!

    private var arrNotificationList = [Notifications.MyNotificationList.MyNotificationListItems]()

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
        let interactor = NotificationsInteractor()
        let presenter = NotificationsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        callToGetNotificationList()
        tableView.register(UINib(nibName: CellIdentifier.notificationDetailsCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.notificationDetailsCell)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.addCustomBackButton(title: "")
        cartCountView.layer.cornerRadius = cartCountView.frame.size.height * 0.5
        cartCountView.layer.masksToBounds = true

        lblMyCartCount.text = "0"

        lblBackTitle.onClick = {
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func actionBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: Do something

    func callToGetNotificationList() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
            let salonId = userData.salon_id {
            EZLoadingActivity.show("Loading...", disableUI: true)
            interactor?.getNotifications(salonId: salonId)
        }
    }
}

extension NotificationsVC {

    func displaySuccess<T: Decodable>(viewModel: T) {
        EZLoadingActivity.hide()
        if let model = viewModel as? Notifications.MyNotificationList.Response {
            if let status = model.status, status == true {
                arrNotificationList.removeAll()
                arrNotificationList = model.data ?? []
                lblMyCartCount.text = arrNotificationList.isEmpty ? "0" : String(format: "%d", arrNotificationList.count)
                self.tableView.reloadData()
            }
            else // Failure
            {
                self.showToast(alertTitle: alertTitle, message: model.message ?? "", seconds: toastMessageDuration)
            }
        }
    }
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
    }

}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if arrNotificationList.isEmpty {
            tableView.setEmptyMessage(TableViewNoData.tableViewNoNotificationsAvailable)
            return 0
        }
        else {
            tableView.restore()
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let notificationCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.notificationDetailsCell, for: indexPath) as? NotificationDetailsCell else {
            return UITableViewCell()
        }
        notificationCell.separatorInset = UIEdgeInsets(top: 0, left: is_iPAD ? 30 : 20, bottom: 0, right: is_iPAD ? 30 : 20)
        notificationCell.selectionStyle = .none
        notificationCell.configureNotification(model: arrNotificationList[indexPath.row])

        return notificationCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
