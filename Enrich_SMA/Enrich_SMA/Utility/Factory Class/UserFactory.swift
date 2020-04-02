//
//  UserFactory.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 13/02/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class UserFactory {

    static let shared = UserFactory()

    func signOutUserFromApp() {
        
        if let userData = UserDefaults.standard.value(MyProfile.GetUserProfile.UserData.self, forKey: UserDefauiltsKeys.k_Key_LoginUser) {
            FirebaseTopicFactory.shared.firebaseTopicUnSubscribe(employeeId: userData.employee_id ?? "", salonId: userData.salon_id ?? "")
            
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn)
        userDefaults.removeObject(forKey: UserDefauiltsKeys.k_Key_LoginUser)
        userDefaults.synchronize()
        let navigationC = LoginNavigtionController.instantiate(fromAppStoryboard: .Login)
        UIApplication.shared.keyWindow?.rootViewController = navigationC
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }

    func needToLogoutFromapp(lastDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        // Today date with time 00:00:00
        let todayDateStr = dateFormatter.string(from: Date())
        //        todayDateStr = todayDateStr.components(separatedBy: " ").first ?? ""
        //        todayDateStr = todayDateStr + " 00:00:00"

        // Last saved date
        if let todayDate = dateFormatter.date(from: todayDateStr), let dateLastEnter = dateFormatter.date(from: lastDate) {
            // today date is greater than last saved date app gets logout
            if todayDate != dateLastEnter {
                return true
            }
        }

        return false
    }
}
