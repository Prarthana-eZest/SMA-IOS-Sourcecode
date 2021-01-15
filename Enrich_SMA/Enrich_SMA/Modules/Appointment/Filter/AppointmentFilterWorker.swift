//
//  AppointmentFilterWorker.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class AppointmentFilterWorker {

    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    var presenter: AppointmentFilterPresentationLogic?

    func postRequestGetFilterDetails(request: AppointmentFilter.GetFilterDetails.Request) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (AppointmentFilter.GetFilterDetails.Response) -> Void = { (response) in
            print(response)
            self.presenter?.presentSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.getFilterDetails.rawValue,
                               body: request,
                               headers: ["X-Request-From": "sma", "Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)"],
                               successHandler: successHandler, errorHandler: errorHandler, method: .post)
    }
}
