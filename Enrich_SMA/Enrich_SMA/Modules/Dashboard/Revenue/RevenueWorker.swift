//
//  RevenueWorker.swift
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

class RevenueWorker {

    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    var presenter: RevenuePresentationLogic?

    func postGetRevenueData(request: Revenue.OneClickData.Request, method: HTTPMethod) {
        // *********** NETWORK CONNECTION

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (Revenue.OneClickData.Response) -> Void = { (response) in
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.getOneClickRevenueData.rawValue,
                               body: request,
                               headers: ["Content-Type": "application/json"],
                               successHandler: successHandler,
                               errorHandler: errorHandler, method: method)
    }
}