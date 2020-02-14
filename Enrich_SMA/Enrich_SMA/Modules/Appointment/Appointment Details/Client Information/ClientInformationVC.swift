//
//  ClientInformationViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 08/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ClientInformationDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

enum MembershipType: String {
    case general = "General"
    case clubMemberShip = "Club Membership"
    case premierMembership = "Premier Membership"
    case eliteMembership = "Elite Membership"
}

class ClientInformationVC: UIViewController, ClientInformationDisplayLogic {
    var interactor: ClientInformationBusinessLogic?

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var tableView: UITableView!

    @IBOutlet weak private var BottonButtonView: UIView!

    @IBOutlet weak private var lblNoRecords: UILabel!

    var customerId: Int?

    var sections = [SectionConfiguration]()

    var appointmentHistory = [ClientInformation.GetAppointnentHistory.Data]()
    var memebershipDetails: MembershipStatusModel?

    var preferenceData = [PointsCellData]()
    var notesData = [PointsCellData]()

    var data = [PointsCellData]()

    var selectedTitleCell = 0

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
        let interactor = ClientInformationInteractor()
        let presenter = ClientInformationPresenter()
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

        getClientPreferences()
        getClientNotes()

        sections.removeAll()
        sections.append(configureSection(idetifier: .generalClientInfo, items: 5, data: []))
        sections.append(configureSection(idetifier: .consulationInfo, items: consulationData.count + 1, data: []))
        sections.append(configureSection(idetifier: .memebershipInfo, items: 5, data: []))
        sections.append(configureSection(idetifier: .historyInfo, items: 5, data: []))

        collectionView.register(UINib(nibName: CellIdentifier.topicCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.topicCell)

        tableView.register(UINib(nibName: CellIdentifier.selectGenderCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.selectGenderCell)
        tableView.register(UINib(nibName: CellIdentifier.tagViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.tagViewCell)
        tableView.register(UINib(nibName: CellIdentifier.headerViewWithTitleCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.headerViewWithTitleCell)
        tableView.register(UINib(nibName: CellIdentifier.membershipStatusCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.membershipStatusCell)
        tableView.register(UINib(nibName: CellIdentifier.serviceHistoryCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.serviceHistoryCell)
        tableView.register(UINib(nibName: CellIdentifier.addNotesSingatureCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.addNotesSingatureCell)

        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)

        lblNoRecords.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        KeyboardAnimation.sharedInstance.beginKeyboardObservation(self.view)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardAnimation.sharedInstance.endKeyboardObservation()
    }

    func reloadClientData() {
        self.data.removeAll()
        self.data.append(contentsOf: self.preferenceData)
        self.data.append(contentsOf: self.notesData)
        print("Data Reloaded")
        self.tableView.reloadData()
    }

    @IBAction func actionAddClientNotes(_ sender: UIButton) {
        print("Add New Notes")
        let addNewNoteVC = AddNewNoteVC.instantiate(fromAppStoryboard: .Appointment)
        self.view.alpha = screenPopUpAlpha
        addNewNoteVC.customerId = "\(customerId ?? 0)"
        self.present(addNewNoteVC, animated: true, completion: nil)

        addNewNoteVC.onDoneBlock = { [unowned self] (result, note) in
            // Do something
            if result {
                print("Note:\(note)")
                self.getClientNotes()
            }
            self.view.alpha = 1.0

        }
    }

    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func getAppointmentHistory() {

        if let customerId = customerId,
            let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {

            EZLoadingActivity.show("Loading...", disableUI: true)

            let request = ClientInformation.GetAppointnentHistory.Request(salon_code: userData.base_salon_code ?? "", employee_code: userData.employee_code ??  "", customer_id: "\(customerId)")
            interactor?.doGetAppointmentHistory(request: request, method: .post)
        }
    }

    func getMembershipDetails() {

        if let customerId = customerId {

            EZLoadingActivity.show("Loading...", disableUI: true)

            let request = ClientInformation.MembershipDetails.Request(customer_id: "\(customerId)")
            interactor?.doGetMembershipDetails(accessToken: self.getAccessToken(), method: .post, request: request)
        }

    }

    func getClientPreferences() {

        if let customerId = customerId {

            EZLoadingActivity.show("Loading...", disableUI: true)

            let request = ClientInformation.Preferences.Request(customer_id: "\(customerId)")
            interactor?.doGetClientPreferences(accessToken: self.getAccessToken(), method: .get, request: request)
        }

    }

    func getClientNotes() {

        if let customerId = customerId {

            EZLoadingActivity.show("Loading...", disableUI: true)

            let request = ClientInformation.ClientNotes.Request(customer_id: "\(customerId)", is_custom: true)
            interactor?.doGetClientNotes(method: .post, request: request)
        }

    }

}

extension ClientInformationVC {

    func displaySuccess<T>(viewModel: T) where T: Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")

        lblNoRecords.isHidden = true

        if let model = viewModel as? ClientInformation.GetAppointnentHistory.Response {

            self.appointmentHistory.removeAll()
            self.appointmentHistory.append(contentsOf: model.data ?? [])
            lblNoRecords.isHidden = !appointmentHistory.isEmpty
            self.tableView.reloadData()
            if !appointmentHistory.isEmpty {
                self.tableView.scrollToTop()
            }
        }
        else if let model = viewModel as? ClientInformation.MembershipDetails.Response,
            model.status == true, let name = model.data?.name, let type = MembershipType(rawValue: name) {

            memebershipDetails = MembershipStatusModel(type: type, validity: model.data?.end_date ?? "-", rewardPoints: "0")
            self.tableView.reloadData()
        }
        else if let model = viewModel as? ClientInformation.Preferences.Response, model.status == true {

            self.preferenceData.removeAll()
            if let data = model.data {

                if let bevarages = data.preferred_bevarages {
                    self.preferenceData.append(PointsCellData(title: "Preferred Beverages", points: [bevarages]))
                }

                if let salons = data.preferred_salon, !salons.isEmpty {
                    let names = salons.compactMap { "\($0.salon_name ?? "")"}
                    self.preferenceData.append(PointsCellData(title: "Preferred Salon", points: names))
                }

                if let stylist = data.preferred_stylist, !stylist.isEmpty {
                    let names = stylist.compactMap {$0.name ?? ""}
                    self.preferenceData.append(PointsCellData(title: "Preferred Stylist", points: names))
                }

            }
            self.reloadClientData()

        }
        else if let model = viewModel as? ClientInformation.ClientNotes.Response, model.status == true {

            self.notesData.removeAll()
            if let data = model.data {

                if let askNotes = data.ask, !askNotes.isEmpty {
                    let notes = askNotes.compactMap {$0.note ?? ""}
                    self.notesData.append(PointsCellData(title: "Ask Notes", points: notes))
                }

                if let observeNotes = data.observe, !observeNotes.isEmpty {
                    let notes = observeNotes.compactMap {$0.note ?? ""}
                    self.notesData.append(PointsCellData(title: "Observe Notes", points: notes))
                }
            }
            self.reloadClientData()
        }
    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
       // showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
}

extension ClientInformationVC: SelectGenderDelegate {

    func actionGender(gender: Gender) {
        print("Selected Gender: \(gender)")
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ClientInformationVC: ClientInformationDelegate {

    func actionOtherServices(indexPath: IndexPath) {

        let vc = ListingVC.instantiate(fromAppStoryboard: .More)
        self.view.alpha = screenPopUpAlpha
        vc.services = appointmentHistory[indexPath.row].services?.compactMap { ServiceListingModel(name: $0.service_name ?? "", price: "\($0.price ?? 0)") } ?? []
        vc.screenTitle = "Services"
        vc.listingType = .appointmentServices
        self.present(vc, animated: true, completion: nil)
        vc.viewDismissBlock = { [unowned self] result in
            // Do something
            self.view.alpha = 1.0
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ClientInformationVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedTitleCell {
        case 0:
            return data.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch selectedTitleCell {
        case 0:
            return data[section].points.count + 1
        case 1:
            return consulationData.count + 2
        case 2:
            return 1
        case 3:
            return appointmentHistory.count

        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch selectedTitleCell {

        case 0:

            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerViewWithTitleCell) as? HeaderViewWithTitleCell else {
                    return UITableViewCell()
                }
                cell.titleLabel.text = data[indexPath.section].title//indexPath.section == 0 ? "Preference" : "Client Notes"
                cell.viewAllButton.isHidden = true
                cell.viewAllButton.isHidden = true
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.pointsCell) as? PointsCell else {
                    return UITableViewCell()
                }
                cell.configureCell(title: data[indexPath.section].points[indexPath.row - 1])
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
                return cell
            }

        case 1:

            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectGenderCell, for: indexPath) as? SelectGenderCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.configureCell(isEditable: false, selectedGender: .male)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == (consulationData.count + 1) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addNotesSingatureCell) as? AddNotesSingatureCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.tagViewCell, for: indexPath) as? TagViewCell else {
                    return UITableViewCell()
                }
                cell.indexPath = indexPath
                cell.configureCell(model: consulationData[indexPath.row - 1])
                cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
                cell.selectionStyle = .none
                return cell
            }

        case 2:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.membershipStatusCell, for: indexPath) as? MembershipStatusCell else {
                return UITableViewCell()
            }
            cell.configureCell(model: memebershipDetails)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            cell.selectionStyle = .none
            return cell

        case 3:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.serviceHistoryCell, for: indexPath) as? ServiceHistoryCell else {
                return UITableViewCell()
            }
            cell.indexPath = indexPath
            cell.delegate = self
            cell.configureCell(model: appointmentHistory[indexPath.row])
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
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
    }

}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension ClientInformationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.topicCell, for: indexPath) as? TopicCell else {
            return UICollectionViewCell()
        }
        cell.configueView(model: SelectedCellModel(title: sections[indexPath.row].title, indexSelected: self.selectedTitleCell == indexPath.row, id: ""))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTitleCell = indexPath.row
        BottonButtonView.isHidden = (indexPath.row != 0)
        collectionView.reloadData()
        tableView.reloadData()

        switch selectedTitleCell {
        case 0:
            getClientPreferences()
            getClientNotes()
        case 1:
            break
        case 2:
            getMembershipDetails()
        case 3:
            getAppointmentHistory()
        default:
            break
        }

    }

}

extension ClientInformationVC {

    func configureSection(idetifier: SectionIdentifier, items: Int, data: Any) -> SectionConfiguration {

        let headerHeight: CGFloat = 60
        var cellWidth: CGFloat = tableView.frame.size.width
        var cellHeight: CGFloat = 50
        let margin: CGFloat = 20

        switch idetifier {

        case .generalClientInfo:

            cellWidth = is_iPAD ? 150 : 100
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight,
                                        cellWidth: cellWidth, showHeader: true, showFooter: false,
                                        headerHeight: headerHeight, footerHeight: 0,
                                        leftMargin: margin, rightMarging: 0, isPagingEnabled: false,
                                        textFont: nil, textColor: .black, items: items, identifier: idetifier, data: data)

        case .consulationInfo:
            cellHeight = is_iPAD ? 250 : 150

            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight,
                                        cellWidth: cellWidth, showHeader: false, showFooter: false,
                                        headerHeight: 0, footerHeight: 0,
                                        leftMargin: 0, rightMarging: 0, isPagingEnabled: false, textFont: nil,
                                        textColor: .black, items: items, identifier: idetifier, data: data)

        case .memebershipInfo:

            cellWidth = is_iPAD ? 150 : 100
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight,
                                        cellWidth: cellWidth, showHeader: true, showFooter: false,
                                        headerHeight: headerHeight, footerHeight: 0, leftMargin: margin,
                                        rightMarging: 0, isPagingEnabled: false, textFont: nil,
                                        textColor: .black, items: items, identifier: idetifier, data: data)

        case .historyInfo:
            cellHeight = is_iPAD ? 250 : 150

            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: cellHeight,
                                        cellWidth: cellWidth, showHeader: false, showFooter: false,
                                        headerHeight: 0, footerHeight: 0, leftMargin: 0, rightMarging: 0,
                                        isPagingEnabled: false, textFont: nil, textColor: .black,
                                        items: items, identifier: idetifier, data: data)

        default :
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: 0,
                                        cellWidth: cellWidth, showHeader: false, showFooter: false,
                                        headerHeight: headerHeight, footerHeight: 0, leftMargin: 0,
                                        rightMarging: 0, isPagingEnabled: false, textFont: nil,
                                        textColor: .black, items: items, identifier: idetifier, data: data)
        }
    }
}
