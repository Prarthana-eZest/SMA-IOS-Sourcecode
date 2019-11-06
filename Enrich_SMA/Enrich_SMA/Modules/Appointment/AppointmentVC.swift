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

protocol AppointmentDisplayLogic: class
{
    func displaySomething(viewModel: Appointment.Something.ViewModel)
}

class AppointmentVC: UIViewController, AppointmentDisplayLogic
{
    var interactor: AppointmentBusinessLogic?
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var completedSelectionView: UIView!
    @IBOutlet weak var ongoingSelectionView: UIView!
    @IBOutlet weak var upcomingSelectionView: UIView!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnOnGoing: UIButton!
    @IBOutlet weak var btnUpComing: UIButton!
    
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
        let interactor = AppointmentInteractor()
        let presenter = AppointmentPresenter()
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
        doSomething()
        tableView.register(UINib(nibName: CellIdentifier.appointmentStatusCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.appointmentStatusCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = Appointment.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Appointment.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    
    @IBAction func actionCompleted(_ sender: UIButton) {
        
        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16){
            btnCompleted.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16){
            btnOnGoing.titleLabel?.font = font
            btnUpComing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = false
        ongoingSelectionView.isHidden = true
        upcomingSelectionView.isHidden = true
    }
    
    
    @IBAction func actionOnGoing(_ sender: UIButton) {
        
        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16){
            btnOnGoing.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16){
            btnCompleted.titleLabel?.font = font
            btnUpComing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = true
        ongoingSelectionView.isHidden = false
        upcomingSelectionView.isHidden = true
    }
    
    
    @IBAction func actionUpComing(_ sender: UIButton) {
        
        if let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16){
            btnUpComing.titleLabel?.font = font
        }
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16){
            btnCompleted.titleLabel?.font = font
            btnOnGoing.titleLabel?.font = font
        }
        completedSelectionView.isHidden = true
        ongoingSelectionView.isHidden = true
        upcomingSelectionView.isHidden = false
    }
    
}

extension AppointmentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.appointmentStatusCell, for: indexPath) as? AppointmentStatusCell else {
            return UITableViewCell()
        }
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
        
        let vc = SOSPopUpVC.instantiate(fromAppStoryboard: .Appointment)
        self.view.alpha = screenPopUpAlpha
        vc.viewDismissBlock = { [unowned self] result in
            // Do something
            self.view.alpha = 1.0
        }
        self.appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
        
        
    }
}
