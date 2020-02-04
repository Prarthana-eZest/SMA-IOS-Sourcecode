//
//  AllReviewsVC.swift
//  EnrichSalon
//
//  Created by Harshal Patil on 19/09/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import UIKit

protocol AllReviewsModuleDisplayLogic: class {
    func displaySuccess<T: Decodable> (viewModel: T)
    func displayError(errorMessage: String?)
}

class AllReviewsVC: UIViewController {
    
    var interactor: AllReviewsModuleBusinessLogic?
    
    @IBOutlet weak private var tableView: UITableView!
    
    @IBOutlet weak private var lblNoRatings: UILabel!
    
    var ratings = [ClientInformation.ClientNotes.NotesData]()
    
    // MARK: Object lifecycle
    
    var customerId:Int?
    
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
        let interactor = AllReviewsModuleInteractor()
        let presenter = AllReviewsModulePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: CellIdentifier.userRatingCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.userRatingCell)
        getRatings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: "Ratings & Reviews")
        self.tableView.separatorColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getRatings() {
        
        if let customerId = customerId{
            
            EZLoadingActivity.show("Loading...", disableUI: true)
            
            let request = ClientInformation.ClientNotes.Request(customer_id:"\(customerId)", is_custom: true)
            interactor?.doGetRatings(method: .post, request: request)
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AllReviewsVC: AllReviewsModuleDisplayLogic {
    
    // MARK: Call Webservice
    
    func displayError(errorMessage: String?) {
        EZLoadingActivity.hide()
        lblNoRatings.isHidden = false
    }
    
    func displaySuccess<T>(viewModel: T) where T : Decodable {
        EZLoadingActivity.hide()
        if let model = viewModel as? ClientInformation.ClientNotes.Response, model.status == true{
            
            self.ratings.removeAll()
            model.data?.ratings?.forEach{
                if self.ratings.count < 3{
                    self.ratings.append($0)
                }
            }
            lblNoRatings.isHidden = !self.ratings.isEmpty
            self.tableView.reloadData()
        }
    }
    
}



extension AllReviewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userRatingCell, for: indexPath) as? UserRatingCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configureCell(model: ratings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
    
}





