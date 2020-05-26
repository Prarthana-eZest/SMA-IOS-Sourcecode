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
            print(response)
            if let sos = response.data?.first(where: {$0.is_read == "0"}) {
                SOSNotification?(sos)
            }
        }

        guard let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser),
            let salon_id = userData.salon_id else {
            return
        }

        let deviceToken: String = GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.salon) + salon_id

        let strURL = ConstantAPINames.getNotificationList.rawValue + "&module=SOS" + "&device_id=\(deviceToken)"
        self.networkLayer.get(urlString: strURL, headers: ["Authorization": "Bearer \(GenericClass.sharedInstance.isuserLoggedIn().accessToken)"],
                              successHandler: successHandler, errorHandler: errorHandler)
    }
}
