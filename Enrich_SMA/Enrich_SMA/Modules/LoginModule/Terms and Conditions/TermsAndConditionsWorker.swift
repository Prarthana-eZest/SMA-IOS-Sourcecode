//
//  TermsAndConditionsWorker.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class TermsAndConditionsWorker
{
    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    var presenter: TermsAndConditionsPresentationLogic?
    
    func getRequestForTermsAndConditions(request:String, method: HTTPMethod) {
        
        let errorHandler: (String) -> Void = { (error) in
            self.presenter?.presentGetTermsAndConditionsError(responseError: error)
        }
       
        let successHandler: (TermsAndConditions.GetTermsAndConditions.Response) -> Void = { (response) in
            self.presenter?.presentGetTermsAndConditionsSuccess(response: response)
        }
        
        let url = ConstantAPINames.getTermsAndConditions.rawValue + request + "&is_custom=true"
        
        self.networkLayer.get(urlString: url, successHandler: successHandler, errorHandler: errorHandler)
    }
    
}
