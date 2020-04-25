//
//  ApprovalRequestListViewController.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/03/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ApprovalRequestListDisplayLogic: class {
    func displaySomething(viewModel: ApprovalRequestList.Something.ViewModel)
}

class ApprovalRequestListVC: UIViewController, ApprovalRequestListDisplayLogic {
    var interactor: ApprovalRequestListBusinessLogic?

    @IBOutlet weak private var tableView: UITableView!

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
        let interactor = ApprovalRequestListInteractor()
        let presenter = ApprovalRequestListPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifier.approvalRequestCell, bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.approvalRequestCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait,
                                         andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Approval Request")
    }


    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func doSomething() {
        let request = ApprovalRequestList.Something.Request()
        interactor?.doSomething(request: request)
    }

    func displaySomething(viewModel: ApprovalRequestList.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension ApprovalRequestListVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let notificationCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.approvalRequestCell, for: indexPath) as? ApprovalRequestCell else {
            return UITableViewCell()
        }
        notificationCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        notificationCell.selectionStyle = .none

        return notificationCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}