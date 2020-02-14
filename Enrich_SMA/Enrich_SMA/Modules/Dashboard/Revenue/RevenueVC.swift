//
//  RevenueViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 11/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RevenueDisplayLogic: class {
    func displaySomething(viewModel: Revenue.Something.ViewModel)
}

class RevenueVC: UIViewController, RevenueDisplayLogic {
    var interactor: RevenueBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!

    let revenues: [RevenueCellModel] = [RevenueCellModel(title: "Revenue multiplier", subTitle: "", value: "0.5"),
                                       RevenueCellModel(title: "YoY revenue growth", subTitle: "", value: "25%"),
                                       RevenueCellModel(title: "Client consultation", subTitle: "From 50 Customer", value: "80%"),
                                       RevenueCellModel(title: "Retail products", subTitle: "", value: "40%"),
                                       RevenueCellModel(title: "Service revenue", subTitle: "", value: "70%"),
                                       RevenueCellModel(title: "Salon achievements", subTitle: "", value: "40%"),
                                       RevenueCellModel(title: "RM consumption of category", subTitle: "", value: "90%"),
                                       RevenueCellModel(title: "Quality", subTitle: "", value: "75%"),
                                       RevenueCellModel(title: "Punctuality on appointments", subTitle: "", value: "80%")]

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
        let interactor = RevenueInteractor()
        let presenter = RevenuePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        tableView.register(UINib(nibName: CellIdentifier.revenueCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.revenueCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Revenue")

    }

    @objc func didTapRevenueButton() {
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func doSomething() {
        let request = Revenue.Something.Request()
        interactor?.doSomething(request: request)
    }

    func displaySomething(viewModel: Revenue.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension RevenueVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revenues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.revenueCell, for: indexPath) as? RevenueCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: revenues[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
}
