//
//  ApprovalRequestListInteractor.swift
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

protocol ApprovalRequestListBusinessLogic {
    func doPostGetApprovalList(request: ApprovalRequestList.GetRequestData.Request, method: HTTPMethod)
    func doPostProcessApproval(request: ApprovalRequestList.ProcessRequest.Request, method: HTTPMethod)
}

class ApprovalRequestListInteractor: ApprovalRequestListBusinessLogic {
    var presenter: ApprovalRequestListPresentationLogic?
    var worker: ApprovalRequestListWorker?
    //var name: String = ""

    // MARK: Do something

    func doPostGetApprovalList(request: ApprovalRequestList.GetRequestData.Request, method: HTTPMethod) {
        worker = ApprovalRequestListWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForApprovalRequestList(request: request, method: method)
    }

    func doPostProcessApproval(request: ApprovalRequestList.ProcessRequest.Request, method: HTTPMethod) {
        worker = ApprovalRequestListWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForProcessRequest(request: request, method: method)
    }
}
