//
//  EmployeeListingInteractor.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EmployeeListingBusinessLogic {
    func doGetEmployeeListData(request: EmployeeListing.GetEmployeeList.Request, method: HTTPMethod)
}

protocol EmployeeListingDataStore {
    //var name: String { get set }
}

class EmployeeListingInteractor: EmployeeListingBusinessLogic, EmployeeListingDataStore {
    var presenter: EmployeeListingPresentationLogic?
    var worker: EmployeeListingWorker?
    //var name: String = ""

    // MARK: Do something

    func doGetEmployeeListData(request: EmployeeListing.GetEmployeeList.Request, method: HTTPMethod) {
        worker = EmployeeListingWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForServiceList(request: request, method: method)
    }
}
