//
//  SOSFactory.swift
//  Enrich_TMA
//
//  Created by Harshal on 02/04/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class SOSFactory {

    static let shared = SOSFactory()

    let networkLayer = NetworkLayerAlamofire()

    func getSOSNotification(SOSNotification: ((Notifications.MyNotificationList.MyNotificationListItems) -> Void)?) {

        let errorHandler: (String) -> Void = { (error) in
            print(error)
        }
        let successHandler: (Notifications.MyNotificationList.Response) -> Void = { response in
            if let sos = response.data?.first(where: {$0.is_read == "0"}) {
                SOSNotification?(sos)
            }
        }

        let strURL = ConstantAPINames.getNotificationList.rawValue + "&module=SSO"
        self.networkLayer.get(urlString: strURL, headers: ["Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)"],
                              successHandler: successHandler, errorHandler: errorHandler)
    }
}
