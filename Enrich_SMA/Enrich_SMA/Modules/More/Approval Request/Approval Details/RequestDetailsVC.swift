//
//  RequestDetailsViewController.swift
//  Enrich_SMA
//
//  Created by Harshal on 05/05/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ModifyRequestCategory: String {
    case add_app = "add_appointment"
    case appointment_timeslot = "change_appointment_timeslot"
    case del_appointment = "delete_appointment"
    case can_appointment = "cancel_appointment"
    case add_new_service = "add_service"
    case replace = "replace_service"
    case service_timeslot = "change_service_timeslot"
    case del_service = "delete_service"
}

protocol RequestDetailsDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class RequestDetailsVC: UIViewController, RequestDetailsDisplayLogic {
    var interactor: RequestDetailsBusinessLogic?
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var btnView: UIView!
    
    // MARK: Object lifecycle
    
    var approvalRequest: ApprovalRequestList.GetRequestData.Data?
    var categories = [RequestCategoryModel]()
    
    var appointmentDate = ""
    
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
        let interactor = RequestDetailsInteractor()
        let presenter = RequestDetailsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: CellIdentifier.requestDetailsCell, bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.requestDetailsCell)
        tableView.register(UINib(nibName: CellIdentifier.requestCategoryCell, bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.requestCategoryCell)
        
        tableView.separatorColor = .clear
        
        if let request = approvalRequest,
            let category = ModifyRequestCategory(rawValue: request.category ?? ""),
            let status = ApprovalStatus(rawValue: request.approval_status ?? "") {
            btnView.isHidden = (status != .noAction)
            configureCatagories(category: category)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait,
                                         andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Request Details")
    }
    
    @IBAction func actionDeny(_ sender: UIButton) {
        
        let vc = DenyReasonVC.instantiate(fromAppStoryboard: .More)
        self.view.alpha = screenPopUpAlpha
        self.present(vc, animated: true, completion: nil)
        
        vc.onDoneBlock = { [unowned self] (result, reason) in
            // Do something
            if result {
                self.processRequestAPICall(
                    type: ApprovalStatus.denied.rawValue, reason: reason)
            }
            self.view.alpha = 1.0
        }
    }
    
    @IBAction func actionApprove(_ sender: UIButton) {
        processRequestAPICall(type: ApprovalStatus.approved.rawValue, reason: nil)
    }
    
    func configureCatagories(category: ModifyRequestCategory) {
        
        self.categories.removeAll()
        
        guard let request = approvalRequest,
            let requestDetails = request.approval_request_details else {
                return
        }
        appointmentDate = requestDetails.appointment?.appointment_date ?? ""
        
        switch category {
            
        case .add_app, .del_appointment, .can_appointment:
            
            if let services = requestDetails.services {
                services.forEach {
                    let customerName = (($0.is_dependant ?? 0) == 1) ? ($0.dependant_name ?? "") : "\($0.customer_name ?? "") \($0.customer_last_name ?? "")"
                    let isDependent = ($0.is_dependant ?? 0) == 1
                    categories.append(RequestCategoryModel(
                        title: $0.service_name,
                        startTime: $0.start_time,
                        endTime: $0.end_time,
                        price: "\($0.price ?? 0)",
                        duration: "\($0.service_duration ?? 0)",
                        customerName: customerName,
                        servicing_technician: $0.servicing_technician, isDependentService: isDependent))
                }
            }
            
        case .appointment_timeslot:
            
            if let original = requestDetails.original {
                categories.append(RequestCategoryModel(
                    title: "Original : \(original.date ?? "")",
                    startTime: original.start_time,
                    endTime: original.end_time,
                    price: original.price?.description,
                    duration: original.total_duration?.description,
                    customerName: nil,
                    servicing_technician: nil,
                    isDependentService: false))
            }
            
            if let requested = requestDetails.requested {
                categories.append(RequestCategoryModel(
                    title: "Requested : \(requested.date ?? "")",
                    startTime: requested.start_time,
                    endTime: requested.end_time,
                    price: requested.price?.description,
                    duration: requested.total_duration?.description,
                    customerName: nil,
                    servicing_technician: nil,
                    isDependentService: false))
            }
            
        case .add_new_service, .del_service:
            
            appointmentDate = requestDetails.service?.first?.appointment_date ?? ""
            
            if let services = requestDetails.service {
                services.forEach {
                    let customerName = (($0.is_dependant ?? 0) == 1) ? ($0.dependant_name ?? "") : $0.booked_for ?? ""
                    let isDependent = ($0.is_dependant ?? 0) == 1
                    
                    categories.append(RequestCategoryModel(
                        title: $0.service_name,
                        startTime: $0.start_time,
                        endTime: $0.end_time,
                        price: "\($0.price ?? 0)",
                        duration: "\($0.service_duration ?? 0)",
                        customerName: customerName,
                        servicing_technician: $0.servicing_technician,
                        isDependentService: isDependent))
                }
            }
            
        case .service_timeslot:
            
            if let service = requestDetails.services?.first {
                
                let customerName = ((service.is_dependant ?? 0) == 1) ? (service.dependant_name ?? "") : "\(service.customer_name ?? "") \(service.customer_last_name ?? "")"
                let isDependent = (service.is_dependant ?? 0) == 1
                
                if let original = requestDetails.original {
                    categories.append(RequestCategoryModel(
                        title: "Original : \(service.service_name ?? "")",
                        startTime: original.start_time,
                        endTime: original.end_time,
                        price: original.price?.description,
                        duration: "\(original.service_duration ?? 0)",
                        customerName: customerName,
                        servicing_technician: service.servicing_technician ?? "",
                        isDependentService: isDependent))
                }
                
                if let requested = requestDetails.requested {
                    categories.append(RequestCategoryModel(
                        title: "Requested : \(service.service_name ?? "")",
                        startTime: requested.start_time,
                        endTime: requested.end_time,
                        price: requested.price?.description, duration: requested.service_duration?.description,
                        customerName: customerName,
                        servicing_technician: service.servicing_technician ?? "",
                        isDependentService: isDependent))
                }
            }
            
        case .replace:
            
            if let firstService = requestDetails.services?.first, let lastService = requestDetails.services?.last {
                
                if let original = requestDetails.original {
                    
                    let customerName = ((firstService.is_dependant ?? 0) == 1) ? (firstService.dependant_name ?? "") : "\(firstService.customer_name ?? "") \(firstService.customer_last_name ?? "")"
                    let isDependent = (firstService.is_dependant ?? 0) == 1
                    
                    categories.append(RequestCategoryModel(
                        title: "Original : \(original.service_name ?? "")",
                        startTime: original.start_time,
                        endTime: original.end_time,
                        price: original.price?.description,
                        duration: "\(original.service_duration ?? 0)",
                        customerName: customerName,
                        servicing_technician: firstService.servicing_technician ?? "",
                        isDependentService: isDependent))
                }
                
                if let requested = requestDetails.requested {
                    
                    let customerName = ((lastService.is_dependant ?? 0) == 1) ? (lastService.dependant_name ?? "") : "\(lastService.customer_name ?? "") \(lastService.customer_last_name ?? "")"
                    let isDependent = (lastService.is_dependant ?? 0) == 1
                    
                    categories.append(RequestCategoryModel(
                        title: "Requested : \(requested.service_name ?? "")",
                        startTime: requested.start_time,
                        endTime: requested.end_time,
                        price: requested.price?.description, duration: requested.service_duration?.description,
                        customerName: customerName,
                        servicing_technician: lastService.servicing_technician ?? "",
                        isDependentService: isDependent))
                }
            }
            
        }
        self.tableView.reloadData()
    }
}

extension RequestDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.requestDetailsCell, for: indexPath) as? RequestDetailsCell else {
                return UITableViewCell()
            }
            if let details = approvalRequest {
                cell.configureCell(model: details, date: appointmentDate)
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.requestCategoryCell, for: indexPath) as? RequestCategoryCell else {
                return UITableViewCell()
            }
            cell.configureCell(model: categories[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Call Webservice
extension RequestDetailsVC {
    
    func processRequestAPICall(type: String, reason: String?) {
        
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
            let requestDetails = approvalRequest {
            EZLoadingActivity.show("Loading...", disableUI: true)
            
            let requestData = ApprovalRequestList.ProcessRequest.RequestDetails(
                status: type, ref_id: requestDetails.ref_id,
                category: requestDetails.category,
                employee_id: userData.employee_id,
                module_name: requestDetails.module_name, reason: reason,
                customer_id: requestDetails.approval_request_details?.appointment?.customer_id)
            let request = ApprovalRequestList.ProcessRequest.Request(addData: requestData, is_custom: true)
            interactor?.doPostProcessApproval(request: request, method: .post)
        }
    }
    
    func displaySuccess<T: Decodable>(viewModel: T) {
        EZLoadingActivity.hide()
        if let model = viewModel as? ApprovalRequestList.ProcessRequest.Response {
            let alertController = UIAlertController(title: alertTitle, message: model.message ?? "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: AlertButtonTitle.ok, style: UIAlertAction.Style.cancel) { _ -> Void in
                if model.status == true {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        DispatchQueue.main.async { [unowned self] in
            self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
        }
    }
}
