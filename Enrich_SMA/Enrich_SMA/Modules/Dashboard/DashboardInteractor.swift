//
//  DashboardInteractor.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DashboardBusinessLogic {
    func doGetMyProfileData(accessToken: String, method: HTTPMethod)
    func doGetDashboardData(request: Dashboard.GetDashboardData.Request, method: HTTPMethod)
}

class DashboardInteractor: DashboardBusinessLogic {
    var presenter: DashboardPresentationLogic?
    var worker: DashboardWorker?
    //var name: String = ""

    // MARK: Do something

    func doGetMyProfileData(accessToken: String, method: HTTPMethod) {
        worker = DashboardWorker()
        worker?.presenter = self.presenter
        worker?.getRequestForUserProfile(accessToken: accessToken, method: method)
    }

    func doGetDashboardData(request: Dashboard.GetDashboardData.Request, method: HTTPMethod) {
        worker = DashboardWorker()
        worker?.presenter = self.presenter
        worker?.postGetDashboardData(request: request, method: method)
    }

}
