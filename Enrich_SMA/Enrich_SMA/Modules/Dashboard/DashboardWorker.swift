//
//  DashboardWorker.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class DashboardWorker
{
    let networkLayer = NetworkLayerAlamofire() // Uncomment this in case do request using Alamofire for client request
    var presenter: DashboardPresentationLogic?
    
    
    func getRequestForUserProfile(accessToken:String, method: HTTPMethod) {
        
        let errorHandler: (String) -> Void = { (error) in
            print(error)
            self.presenter?.presentError(responseError: error)
        }
        let successHandler: (MyProfile.GetUserProfile.Response) -> Void = { (response) in
            print(response)
            self.presenter?.presentGetProfileSuccess(response: response)
        }
        
        self.networkLayer.get(urlString: ConstantAPINames.getUserProfile.rawValue, headers: ["Authorization": "Bearer \(accessToken)"], successHandler: successHandler, errorHandler: errorHandler)
        
    }
}
