//
//  AppointmentDetailsViewController.swift
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

protocol AppointmentDetailsDisplayLogic: class {
    func displaySomething(viewModel: AppointmentDetails.Something.ViewModel)
}

class AppointmentDetailsVC: UIViewController, AppointmentDetailsDisplayLogic {
    var interactor: AppointmentDetailsBusinessLogic?

    @IBOutlet weak private var btnBeginAppoinement: UIButton!
    @IBOutlet weak private var tableView: UITableView!

    // MARK: Object lifecycle

    var appointmentDetails: Appointment.GetAppointnents.Data?

    var selectedDate: Date = Date()

    var appintmentTimeLine: [AppointmentTimelineModel] = []

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
        let interactor = AppointmentDetailsInteractor()
        let presenter = AppointmentDetailsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            //      if let router = router, router.responds(to: selector) {
        //            //        router.perform(selector, with: segue)
        //            //      }
        //        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        tableView.register(UINib(nibName: CellIdentifier.appointmentDetailsCell, bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.appointmentDetailsCell)
        tableView.register(UINib(nibName: CellIdentifier.appointmentTimelineCell, bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.appointmentTimelineCell)

        tableView.separatorColor = .clear
        showNavigationBarButtons()
        configureTimeline()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait,
                                         andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "")
    }

    // MARK: - Top Navigation Bar And  Actions
    func showNavigationBarButtons() {

        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        guard let sosImg = UIImage(named: "SOS") else {
                return
        }

        let sosButton = UIBarButtonItem(image: sosImg, style: .plain, target: self, action: #selector(didTapSOSButton))
        sosButton.tintColor = UIColor.black

        navigationItem.title = ""
        navigationItem.rightBarButtonItems = [sosButton]

    }

    @objc func didTapSOSButton() {

    }

    // MARK: Do something

    func doSomething() {
        let request = AppointmentDetails.Something.Request()
        interactor?.doSomething(request: request)
    }

    func displaySomething(viewModel: AppointmentDetails.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }

    @IBAction func actionClientInformation(_ sender: UIButton) {
        let vc = ClientInformationVC.instantiate(fromAppStoryboard: .Appointment)
        vc.customerId = self.appointmentDetails?.booked_by_id
        vc.gender = self.appointmentDetails?.gender ?? 1
        if let forms = appointmentDetails?.generic_form_list {
            vc.form_id = forms.first?.form_id
        }
        self.present(vc, animated: true, completion: nil)
    }

    func configureTimeline() {
        self.appintmentTimeLine.removeAll()
        appointmentDetails?.services?.forEach {
            self.appintmentTimeLine.append(AppointmentTimelineModel(time: $0.start_time ?? "",
                                                                    title: $0.service_name ?? "",
                                                                    subTitle: $0.servicing_technician ?? "",
                                                                    alreadyCovered: $0.status == "completed"))
        }
        self.appintmentTimeLine.append(AppointmentTimelineModel(time: appointmentDetails?.services?.last?.end_time ?? "",
                                                                title: "Appointment ends",
                                                                subTitle: "", alreadyCovered: false))
        self.tableView.reloadData()
    }

}

extension AppointmentDetailsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return (appointmentDetails?.services?.count ?? 0) > 0 ? 3 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 2 ? appintmentTimeLine.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.appointmentDetailsCell, for: indexPath) as? AppointmentDetailsCell else {
                return UITableViewCell()
            }
            if let model = appointmentDetails {
                cell.configureCell(model: model, date: selectedDate)
            }
            cell.selectionStyle = .none
            return cell

        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.appointmentTimelineHeader, for: indexPath)
            cell.selectionStyle = .none
            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.appointmentTimelineCell, for: indexPath) as? AppointmentTimelineCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureCell(model: appintmentTimeLine[indexPath.row],
                               isEndCell: (indexPath.row == (appintmentTimeLine.count - 1)))
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
