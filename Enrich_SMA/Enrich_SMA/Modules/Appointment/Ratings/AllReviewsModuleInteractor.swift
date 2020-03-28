//
//  AllReviewsModuleInteractor.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

protocol AllReviewsModuleBusinessLogic {
    func doGetCustomerRatings(method: HTTPMethod, request: ClientInformation.ClientNotes.Request)
    func doGetSalonRatings(method: HTTPMethod, request: AllReviewsModule.SalonRatings.Request)
}

protocol AllReviewsModuleDataStore {
    //var name: String { get set }
}

class AllReviewsModuleInteractor: AllReviewsModuleBusinessLogic, AllReviewsModuleDataStore {

    var presenter: AllReviewsModulePresentationLogic?
    var worker: AllReviewsModuleWorker?
    //var name: String = ""

    // MARK: Do something

    // MARK: Do something
    func doGetCustomerRatings(method: HTTPMethod, request: ClientInformation.ClientNotes.Request) {
        worker = AllReviewsModuleWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForCustomerRatings(request: request, method: method)
    }

    func doGetSalonRatings(method: HTTPMethod, request: AllReviewsModule.SalonRatings.Request) {
        worker = AllReviewsModuleWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForSalonRatings(request: request, method: method)
    }

}
