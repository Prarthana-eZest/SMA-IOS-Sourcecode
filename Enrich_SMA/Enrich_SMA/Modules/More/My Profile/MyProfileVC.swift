//
//  MyProfileViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 16/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyProfileDisplayLogic: class
{
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

enum ProfileType {
    case otherUser,selfUser
}

enum ListingType:String{
    case services = "Service Expertise"
    case shifts = "Shift Timing"
    case appointmentServices = "Services"
}

class MyProfileVC: UIViewController, MyProfileDisplayLogic
{
    
    var interactor: MyProfileBusinessLogic?
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileType:ProfileType = .selfUser
    
    var profileSections = [MyProfileSection]()
    
    var profileHeader: MyProfileHeaderModel?
    
    var employeeId: Int?
    var employeeCode: String?
    
    var service = [String]()
    var rosterList = [String]()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = MyProfileInteractor()
        let presenter = MyProfilePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            if let router = router, router.responds(to: selector) {
        //                router.perform(selector, with: segue)
        //            }
        //        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: CellIdentifier.myProfileHeaderCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.myProfileHeaderCell)
        tableView.register(UINib(nibName: CellIdentifier.myProfileCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.myProfileCell)
        tableView.register(UINib(nibName: CellIdentifier.myProfileMultiOptionCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.myProfileMultiOptionCell)
        
        tableView.register(UINib(nibName: CellIdentifier.headerViewWithTitleCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.headerViewWithTitleCell)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)

        
        getProfileData()
        getRosterDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: profileType == .selfUser ? "My Profile" : "Profile Details")
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func getProfileData()  {
        EZLoadingActivity.show("Loading...", disableUI: true)
        interactor?.doGetMyProfileData(employeeId:employeeId,accessToken: GenericClass.sharedInstance.isuserLoggedIn().accessToken, method: HTTPMethod.get)
    }
    
    func getServiceList()  {
        EZLoadingActivity.show("Loading...", disableUI: true)
        interactor?.doGetServiceListData(accessToken: self.isuserLoggedIn().accessToken, method: .get)
    }
    
    func getRosterDetails()  {
        
        if let startDate = Date().startOfWeek,let endDate = Date().endOfWeek{
            
            if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
                
                EZLoadingActivity.show("Loading...", disableUI: true)
                
                let id = (profileType == .selfUser ? (userData.employee_id ?? "0") : "\(employeeId ?? 0)")
                
                let request = MyProfile.GetRosterDetails.Request(salon_code: userData.base_salon_code ?? "", fromDate: startDate.dayYearMonthDate, toDate: endDate.dayYearMonthDate, employee_id: id)
                interactor?.doGetRosterData(request: request, method: .post)
            }
        }
    }
    
    
    func displaySuccess<T>(viewModel: T) where T : Decodable {
        EZLoadingActivity.hide()
        print("Response: \(viewModel)")
        if let model = viewModel as? MyProfile.GetUserProfile.Response,model.status == true{
            modelMapping(model: model)
        }else if let model = viewModel as? MyProfile.GetServiceList.Response,model.status == true{
            self.service.removeAll()
            self.service.append(contentsOf: model.data?.service_list ?? [])
        }else if let model = viewModel as? MyProfile.GetRosterDetails.Response,model.status == true{
            self.rosterList.removeAll()
            model.data?.forEach{
                let shift = "\($0.date ?? "-")  |  \($0.shift_name ?? "-")  |  \($0.start_time ?? "-") - \($0.end_time ?? "-")"
                self.rosterList.append(shift)
            }
        }
    }
    
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        print("Failed: \(errorMessage ?? "")")
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
    }
    
    
}
extension MyProfileVC: ProfileCellDelegate{
    
    func actionViewDetails(indexPath: IndexPath,type: ListingType) {
        
        let vc = ListingVC.instantiate(fromAppStoryboard: .More)
        self.view.alpha = screenPopUpAlpha
        
        switch type {
            
        case .services:
            vc.listing = service
            vc.listingType = .services
            
        case .shifts:
            vc.listing = rosterList
            vc.listingType = .shifts
            
        default:break
        }
        
        appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
        vc.viewDismissBlock = { [unowned self] result in
            // Do something
            self.view.alpha = 1.0
        }
    }
}

extension MyProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileSections.count + (profileHeader != nil ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : profileSections[section - 1].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.myProfileHeaderCell, for: indexPath) as? MyProfileHeaderCell else {
                return UITableViewCell()
            }
            
            if let model = profileHeader{
                cell.configureCell(model: model)
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
            
        default:
            
            let model = profileSections[indexPath.section - 1].data[indexPath.row]
            
            if model.isMultiOption{
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.myProfileMultiOptionCell, for: indexPath) as? MyProfileMultiOptionCell else {
                    return UITableViewCell()
                }
                cell.indexPath = indexPath
                cell.delegate = self
                if let type = ListingType(rawValue: model.title){
                    cell.listingType = type
                }
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureCell(title:model.title)
                return cell
                
            }else{
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.myProfileCell, for: indexPath) as? MyProfileCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureCell(model: model)
                return cell
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return nil
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerViewWithTitleCell) as? HeaderViewWithTitleCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = profileSections[section - 1].title
        cell.viewAllButton.isHidden = true
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
}


extension MyProfileVC{
    
    func modelMapping(model:MyProfile.GetUserProfile.Response){
        
        if let data = model.data{
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodable: data, forKey: UserDefauiltsKeys.k_Key_LoginUser)
            userDefaults.synchronize()
            
            let header = MyProfileHeaderModel(profilePictureURL: data.profile_pic ?? "", userName: "\(data.firstname ?? "") \(data.lastname ?? "")", speciality: data.designation ?? "-", dateOfJoining: data.joining_date ?? "-", ratings: data.rating,gender: data.gender ?? "1")
            
            var addressString = ["\(data.address?.first?.line_1 ?? "" )",
                "\(data.address?.first?.line_2 ?? "" )",
                "\(data.address?.first?.city ?? "" )",
                "\(data.address?.first?.state ?? "" )",
                "\(data.address?.first?.country ?? "" )"]
            addressString.removeAll(where: {$0.isEmpty})
            let address = addressString.joined(separator:", ")
            let status = data.status ?? ""
            
            let personalDetails = MyProfileSection(title:"Personal details",data:[MyProfileModel(title:"Date of Birth",value:data.birthdate ?? "-",isMultiOption:false),
                                                                                  MyProfileModel(title:"Mobile Number",value: data.mobile_number ?? "-",isMultiOption:false),
                                                                                  MyProfileModel(title:"Other Contact Number",value:data.work_number ?? "-",isMultiOption:false),
                                                                                  MyProfileModel(title:"Email address",value: data.email ?? "-",isMultiOption:false),MyProfileModel(title:"Address",value:address,isMultiOption:false)])
            
            
            let professionalDetails = MyProfileSection(title:"Professional details",data:[MyProfileModel(title:"Employee ID",value:data.employee_code ?? "-",isMultiOption:false),
                                                                                          MyProfileModel(title:"Nick Name",value:data.nickname ?? "-",isMultiOption:false),
                                                                                          MyProfileModel(title:"Center",value:data.base_salon_name ?? "-",isMultiOption:false),
                                                                                          MyProfileModel(title:"Category",value:data.category ?? "-",isMultiOption:false),
                                                                                          MyProfileModel(title:"Designation",value:data.designation ?? "-",isMultiOption:false)])
            
            var shiftDetails = MyProfileSection(title:"Shift details",data:[MyProfileModel(title:"Shift Timing",value:"-",isMultiOption:true),
                                                                            MyProfileModel(title:"Status",value: status == "1" ? "Active" : "Inactive",isMultiOption:false)])
            
            
            let sections = [personalDetails,professionalDetails,shiftDetails]
            
            self.profileSections.removeAll()
            self.profileHeader = header
            self.profileSections.append(contentsOf: sections)
            self.tableView.reloadData()
        }
    }
}
