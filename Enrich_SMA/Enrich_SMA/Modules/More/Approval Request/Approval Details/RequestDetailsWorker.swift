//
//  RequestDetailsWorker.swift
//  Enrich_SMA
//
//  Created by Harshal on 05/05/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class RequestDetailsWorker {

    let networkLayer = NetworkLayerAlamofire()
    // Uncomment this in case do request using Alamofire for client request
    // let networkLayer = NetworkLayer() // Uncomment this in case do request using URLsession
    var presenter: RequestDetailsPresentationLogic?

    func postRequestForApprovalRequestList(request: ApprovalRequestList.GetRequestData.Request, method: HTTPMethod) {
        // *********** NETWORK CONNECTION

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (ApprovalRequestList.GetRequestData.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.getApprovalList.rawValue, body: request,
                               headers: ["Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)",
                                "Content-Type": "application/json",
                                "X-Request-From": "sma"],
                               successHandler: successHandler, errorHandler: errorHandler, method: method)
    }

    func postRequestForProcessRequest(request: ApprovalRequestList.ProcessRequest.Request, method: HTTPMethod) {
        // *********** NETWORK CONNECTION

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (ApprovalRequestList.ProcessRequest.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.processApprovalRequest.rawValue, body: request,
                               headers: ["Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)",
                               "Content-Type": "application/json",
                               "X-Request-From": "sma"],
                               successHandler: successHandler, errorHandler: errorHandler, method: method)
    }
}