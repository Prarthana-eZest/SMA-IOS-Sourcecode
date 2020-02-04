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
    func doGetRatings(method: HTTPMethod, request: ClientInformation.ClientNotes.Request)
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
    func doGetRatings(method: HTTPMethod, request: ClientInformation.ClientNotes.Request) {
        worker = AllReviewsModuleWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForRatings(request: request, method: method)
    }

}
