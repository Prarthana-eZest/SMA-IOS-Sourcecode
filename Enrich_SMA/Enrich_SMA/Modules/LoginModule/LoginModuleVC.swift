//
//  LoginModuleViewController.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit
protocol LoginModuleDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class LoginModuleVC: DesignableViewController, LoginModuleDisplayLogic {

    var interactor: LoginModuleBusinessLogic?

    @IBOutlet weak private var txtfEnrichId: UITextField!
    @IBOutlet weak private var txtfPassword: UITextField!
    @IBOutlet weak private var btnLogin: UIButton!
    @IBOutlet weak private var iconImage: UIImageView!

    var termsAccpeted = false

    var fromTerms = false

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
        let interactor = LoginModuleInteractor()
        let presenter = LoginModulePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txtfEnrichId.delegate = self
        txtfPassword.delegate = self
        [txtfEnrichId, txtfPassword].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        KeyboardAnimation.sharedInstance.beginKeyboardObservation(self.view)
        if !fromTerms {
            self.txtfEnrichId.text = ""
            self.txtfPassword.text = ""
        }
        fromTerms = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        KeyboardAnimation.sharedInstance.endKeyboardObservation()
    }

    deinit {
        removeKeyboardObserver()
    }

    // MARK: IBActions

    @IBAction func actionTermsConditions(_ sender: UIButton) {
        fromTerms = true
        let vc = TermsAndConditionsVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.viewDismissBlock = { [unowned self] result in
            // Do something
            self.termsAccpeted = result
        }
    }

    @IBAction func actionLogin(_ sender: UIButton) {

        if sender.isEnabled,
            let username = txtfEnrichId.text,
            let password = txtfPassword.text {
            EZLoadingActivity.show("", disableUI: true)
            let user = LoginModule.UserLogin.Request(username: username,
                                                     password: password,
                                                     is_custom: true,
                                                     accept_terms: termsAccpeted)
            interactor?.doPostRequest(request: user, method: .post)
        }
    }

    @IBAction func actionForgotPassword(_ sender: UIButton) {
        let vc = LoginOTPModuleVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Call Webservice
extension LoginModuleVC {

    func displaySuccess<T: Decodable>(viewModel: T) {

        EZLoadingActivity.hide()

        if let obj = viewModel as? LoginModule.UserLogin.Response,
            obj.status,
            let data = obj.data {
            let userDefaults = UserDefaults.standard
            userDefaults.set(data.access_token, forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn)
            userDefaults.synchronize()

            FirebaseTopicFactory.shared.firebaseTopicSubscribe(employeeId: data.employee_id ?? "", salonId: data.salon_id ?? "")
        }

        let customTabbarController = CustomTabbarController.instantiate(fromAppStoryboard: .HomeLanding)
        UIApplication.shared.keyWindow?.rootViewController = customTabbarController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()

    }

    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "Request Failed")
        self.view.isUserInteractionEnabled = true
    }
}

extension LoginModuleVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginModuleVC {
    @objc func editingChanged(_ textField: UITextField) {
        btnLogin.isEnabled = false
        iconImage.image = UIImage(named: ImageNames.disabledLogo.rawValue)
        let enrichId = (txtfEnrichId.text ?? "").trim()
        let password = (txtfPassword.text ?? "").trim()
        if !enrichId.isEmpty,
            !password.isEmpty {
            btnLogin.isEnabled = true
            iconImage.image = UIImage(named: ImageNames.enabledLogo.rawValue)
        }
    }
}
