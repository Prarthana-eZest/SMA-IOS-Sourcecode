//
//  AllReviewsModulePresenter.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

protocol AllReviewsModulePresentationLogic {
    func presentGetRatingsSuccess<T: Decodable>(response: T)
    func presentError(responseError: String?)
}

class AllReviewsModulePresenter: AllReviewsModulePresentationLogic {
  weak var viewController: AllReviewsModuleDisplayLogic?

  // MARK: Do something

    // MARK: Do something
    func presentGetRatingsSuccess<T: Decodable>(response: T) {
        viewController?.displaySuccess(viewModel: response)
    }
    func presentError(responseError: String? ) {
        viewController?.displayError(errorMessage: responseError)
    }
}
