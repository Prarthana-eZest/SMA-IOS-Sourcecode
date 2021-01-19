//
//  ListingPresenter.swift
//  Enrich_SMA
//
//  Created by Harshal on 14/07/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListingPresentationLogic {
    func presentGetServiceListSuccess<T: Decodable>(response: T)
    func presentGetRosterDetailsSuccess<T: Decodable>(response: T)
    func presentError(responseError: String?)
}

class ListingPresenter: ListingPresentationLogic {
    weak var viewController: ListingDisplayLogic?

    // MARK: Do something

    func presentGetServiceListSuccess<T>(response: T) where T: Decodable {
        viewController?.displaySuccess(viewModel: response)
    }

    func presentGetRosterDetailsSuccess<T>(response: T) where T: Decodable {
        viewController?.displaySuccess(viewModel: response)
    }

    func presentError(responseError: String?) {
        viewController?.displayError(errorMessage: responseError)
    }
}