//
//  AppointmentViewController.swift
//  Enrich_SMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AppointmentDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

enum AppointmentType {
    case completed, ongoing, upcoming
}

class AppointmentVC: UIViewController, AppointmentDisplayLogic {
    var interactor: AppointmentBusinessLogic?
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var completedSelectionView: UIView!
    @IBOutlet weak private var ongoingSelectionView: UIView!
    @IBOutlet weak private var upcomingSelectionView: UIView!
    @IBOutlet weak private var btnCompleted: UIButton!
    @IBOutlet weak private var btnOnGoing: UIButton!
    @IBOutlet weak private var btnUpComing: UIButton!
    @IBOutlet weak private var lblLocation: UILabel!
    @IBOutlet weak private var lblNoAppointments: UILabel!

    var appointments = [Appointment.GetAppointnents.Data]()

    var selectedTab: AppointmentType = .ongoing

    var totalRecords = 0
    var pageNumber = 1
    let limit = 10

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
        let interactor = AppointmentInteractor()
        let presenter = AppointmentPresenter()
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

        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnOnGoing.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnCompleted.titleLabel?.font = font
            btnUpComing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = true
        ongoingSelectionView.isHidden = false
        upcomingSelectionView.isHidden = true

        tableView.register(UINib(nibName: CellIdentifier.appointmentStatusCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.appointmentStatusCell)
        tableView.separatorColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            lblLocation.text = userData.base_salon_name ?? ""
        }
        checkForSOSNotification()
        resetData(status: selectedTab)
    }

    func resetData(status: AppointmentType) {
        pageNumber = 1
        totalRecords = 0
        appointments.removeAll()
        getAppointments(status: status)
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func getAppointments(status: AppointmentType) {

        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {

            EZLoadingActivity.show("Loading...", disableUI: true)

            let request = Appointment.GetAppointnents.Request(status: "\(status)", salon_code: userData.base_salon_code ?? "", date: Date().dayYearMonthDate)
            interactor?.doGetAppointmentList(request: request, method: .post)
        }
    }

    @IBAction func actionCompleted(_ sender: UIButton) {

        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnCompleted.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnOnGoing.titleLabel?.font = font
            btnUpComing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = false
        ongoingSelectionView.isHidden = true
        upcomingSelectionView.isHidden = true
        selectedTab = .completed
        resetData(status: .completed)
    }

    @IBAction func actionOnGoing(_ sender: UIButton) {

        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnOnGoing.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnCompleted.titleLabel?.font = font
            btnUpComing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = true
        ongoingSelectionView.isHidden = false
        upcomingSelectionView.isHidden = true
        selectedTab = .ongoing
        resetData(status: .ongoing)
    }

    @IBAction func actionUpComing(_ sender: UIButton) {

        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16) {
            btnUpComing.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            btnCompleted.titleLabel?.font = font
            btnOnGoing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = true
        ongoingSelectionView.isHidden = true
        upcomingSelectionView.isHidden = false
        selectedTab = .upcoming
        resetData(status: .upcoming)
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

extension AppointmentVC {

    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")

        if let model = viewModel as? Appointment.GetAppointnents.Response {
           print("Page No: \(pageNumber)")
            if pageNumber == 1 {
                self.appointments.removeAll()
            }
            self.appointments.append(contentsOf: model.data ?? [])
            self.tableView.reloadData()
            if !appointments.isEmpty, pageNumber == 1 {
                self.tableView.scrollToTop()
            }
            lblNoAppointments.isHidden = (!appointments.isEmpty)
        }
    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        self.appointments.removeAll()
        self.lblNoAppointments.isHidden = false
        self.tableView.reloadData()
        // showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
}

extension AppointmentVC: AppointmentDelegate {

    func actionDelete(indexPath: IndexPath) {
    }

    func actionModify(indexPath: IndexPath) {
    }

    func actionViewAll() {
    }

    func servicesAction(indexPath: IndexPath) {

        let appointment = appointments[indexPath.row]

        let vc = ListingVC.instantiate(fromAppStoryboard: .More)
        self.view.alpha = screenPopUpAlpha
        vc.services = appointment.services?.compactMap { ServiceListingModel(name: $0.service_name ?? "", price: "\($0.price ?? 0)") } ?? []
        vc.screenTitle = "Services"
        vc.listingType = .appointmentServices
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        vc.viewDismissBlock = { [unowned self] result in
            // Do something
            self.view.alpha = 1.0
        }
    }

    func actionRatings(indexPath: IndexPath) {
        if let id = appointments[indexPath.row].booked_by_id {
            let vc = AllReviewsVC.instantiate(fromAppStoryboard: .Appointment)
            vc.customerId = id
            vc.ratingType = .customer
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AppointmentVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.appointmentStatusCell, for: indexPath) as? AppointmentStatusCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: appointments[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectionStyle = .none
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")

        //        let vc = SOSPopUpVC.instantiate(fromAppStoryboard: .Appointment)
        //        self.view.alpha = screenPopUpAlpha
        //        vc.viewDismissBlock = { [unowned self] result in
        //            // Do something
        //            self.view.alpha = 1.0
        //        }
        //        appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
        let appointment = appointments[indexPath.row]
        if let dateString = appointment.appointment_date,
            let date = dateString.getDateFromString() {
            let vc = AppointmentDetailsVC.instantiate(fromAppStoryboard: .Appointment)
            vc.appointmentDetails = appointments[indexPath.row]
            vc.selectedDate = date
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (appointments.count - 1) &&
            appointments.count < totalRecords {
            pageNumber += 1
            self.resetData(status: selectedTab)
        }
    }
}
