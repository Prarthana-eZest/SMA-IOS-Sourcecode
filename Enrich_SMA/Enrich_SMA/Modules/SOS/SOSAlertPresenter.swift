//
//  SOSAlertPresenter.swift
//  Enrich_SMA
//
//  Created by Harshal on 03/04/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SOSAlertPresentationLogic
{
    func presentSuccess<T: Decodable>(response: T)
    func presentError(responseError: String?)
}

class SOSAlertPresenter: SOSAlertPresentationLogic
{
    weak var viewController: SOSAlertDisplayLogic?
    
    // MARK: Do something
    func presentSuccess<T: Decodable>(response: T) {
        viewController?.displaySuccess(viewModel: response)
    }
    func presentError(responseError: String? ) {
        viewController?.displayError(errorMessage: responseError)
    }
}