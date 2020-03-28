//
//  AllReviewsModuleWorker.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

class AllReviewsModuleWorker {
    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    // let networkLayer = NetworkLayer() // Uncomment this in case do request using URLsession
    var presenter: AllReviewsModulePresentationLogic?

    func postRequestForCustomerRatings(request: ClientInformation.ClientNotes.Request, method: HTTPMethod) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (ClientInformation.ClientNotes.Response) -> Void = { (response) in
            print(response)
            self.presenter?.presentGetRatingsSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.clientNotes.rawValue, body: request, headers: [:], successHandler: successHandler, errorHandler: errorHandler, method: .post)

    }

    func postRequestForSalonRatings(request: AllReviewsModule.SalonRatings.Request, method: HTTPMethod) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (AllReviewsModule.SalonRatings.Response) -> Void = { (response) in
            print(response)
            self.presenter?.presentGetRatingsSuccess(response: response)
        }

        self.networkLayer.post(urlString: ConstantAPINames.getSalonRatings.rawValue, body: request, headers: [:], successHandler: successHandler, errorHandler: errorHandler, method: .post)

    }

}
