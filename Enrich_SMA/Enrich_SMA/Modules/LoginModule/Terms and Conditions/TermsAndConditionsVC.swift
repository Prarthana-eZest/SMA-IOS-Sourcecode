//
//  TermsAndConditionsViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TermsAndConditionsDisplayLogic: class
{
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class TermsAndConditionsVC: UIViewController, UITextViewDelegate,TermsAndConditionsDisplayLogic
{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnAccept: UIButton!
    
    var viewDismissBlock: ((Bool) -> Void)?
    
    var interactor: TermsAndConditionsBusinessLogic?
    
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
        let interactor = TermsAndConditionsInteractor()
        let presenter = TermsAndConditionsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getTermsAndConditions()
        textView.delegate = self
        textView.isEditable = false
        btnAccept.isSelected = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !btnAccept.isSelected{
            btnAccept.isSelected = !(scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Enrich Terms & Conditions")
    }
    
    
    @IBAction func actionAccept(_ sender: Any) {
        if btnAccept.isSelected{
            self.navigationController?.popViewController(animated:true)
            viewDismissBlock?(true)
        }
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Get Search data
    func parseData() -> [FilterKeys] {
        var arrForKeysValues: [FilterKeys] = []
        
        arrForKeysValues.append(FilterKeys(field: "identifier", value: "emp_terms_conditions", type: "="))
        
        return arrForKeysValues
    }
    
    func getTermsAndConditions()
    {
        let query =  GenericClass.sharedInstance.getURLForType(arrSubCat_type: self.parseData())
        print("query : \(query)")
        interactor?.doGetTermsAndConditons(request: query, method: .get)
    }
    
    func displaySuccess<T: Decodable>(viewModel: T) {
        if let obj = viewModel as? TermsAndConditions.GetTermsAndConditions.Response{
            print(obj)
            let attributeString = NSMutableAttributedString(string: obj.items?.first?.content ?? "")
            self.textView.attributedText = attributeString
        }
        
    }
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        DispatchQueue.main.async { [unowned self] in
            self.showAlert(alertTitle: alertTitle, alertMessage: errorMessage ?? "")
        }
    }
}
