//
//  SOSAlertViewController.swift
//  Enrich_SMA
//
//  Created by Harshal on 03/04/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SOSAlertDisplayLogic: class
{
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class SOSAlertVC: UIViewController, SOSAlertDisplayLogic
{
    var interactor: SOSAlertBusinessLogic?
    
    @IBOutlet weak private var profilePicture: UIImageView!
    @IBOutlet weak private var lblUserName: UILabel!
    @IBOutlet weak private var lblLevel: UILabel!
    @IBOutlet weak private var btnMobileNo: UIButton!
    @IBOutlet weak private var lblAddress: UILabel!
    @IBOutlet weak private var txtfMessage: UITextField!
    @IBOutlet weak private var btnOk: UIButton!
    
    var viewDismissBlock: ((Bool) -> Void)?
    
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
        let interactor = SOSAlertInteractor()
        let presenter = SOSAlertPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    

    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func actionMobileNo(_ sender: UIButton) {
    }

    @IBAction func actionOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock?(true)
    }
}

// MARK: Call Webservice
extension SOSAlertVC {

    func sendSOSFeedback() {
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            EZLoadingActivity.show("Loading...", disableUI: true)
            let request = SOSAlert.SendFeedback.Request(employee_id: "", message: txtfMessage.text ?? "", sent_by_id: "", is_custom: 1, acknowledgedNotificationId: "")
            interactor?.doPostSendSOSFeedback(request: request, method: .post)
        }
    }

    func displaySuccess<T: Decodable>(viewModel: T) {
        EZLoadingActivity.hide()
        if let model = viewModel as? SOSAlert.SendFeedback.Response,
            model.status == true {
            viewDismissBlock?(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        DispatchQueue.main.async { [unowned self] in
            self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
        }
    }
}
