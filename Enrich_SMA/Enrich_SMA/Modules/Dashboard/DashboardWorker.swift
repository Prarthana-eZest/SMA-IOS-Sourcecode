//
//  DashboardWorker.swift
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

class DashboardWorker {
    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    var presenter: DashboardPresentationLogic?

    func getRequestForUserProfile(accessToken: String, method: HTTPMethod) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (MyProfile.GetUserProfile.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.get(urlString: ConstantAPINames.getUserProfile.rawValue, headers: ["Authorization": "Bearer \(accessToken)"], successHandler: successHandler, errorHandler: errorHandler)

    }

    func postGetDashboardData(request: Dashboard.GetDashboardData.Request, method: HTTPMethod) {
        // *********** NETWORK CONNECTION

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (Dashboard.GetDashboardData.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.getDashboardData.rawValue,
                               body: request, headers: ["Content-Type": "application/json"],
                               successHandler: successHandler,
                               errorHandler: errorHandler, method: method)
    }

    func getForceUpdateInfo() {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (Dashboard.GetForceUpadateInfo.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.get(urlString: ConstantAPINames.getForceUpdateInfo.rawValue,
                              headers: [:],
                              successHandler: successHandler,
                              errorHandler: errorHandler)

    }
    
    func postRequestGetBMTDashboard(request: Dashboard.GetBMTDashboard.Request) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (Dashboard.GetBMTDashboard.Response) -> Void = { (response) in
           // print(response)
            self.presenter?.presentSuccess(response: response)
        }

        let url = ConstantAPINames.getBMTDashboard.rawValue

        self.networkLayer.post(urlString: url, body: request, headers: ["X-Request-From": "sma", "Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)"],
                               successHandler: successHandler, errorHandler: errorHandler, method: .post)
    }
    
    //get revenue response
    func postRequestGetRevenueDashboard(request: Dashboard.GetRevenueDashboard.Request) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (Dashboard.GetRevenueDashboard.Response) -> Void = { (response) in
           // print(response)
            self.presenter?.presentSuccess(response: response)
        }

        let url = ConstantAPINames.getRevenueDashboard.rawValue

        self.networkLayer.get(urlString: url, headers: ["X-Request-From": "tma", "Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)"], successHandler: successHandler, errorHandler: errorHandler)
    }
}
