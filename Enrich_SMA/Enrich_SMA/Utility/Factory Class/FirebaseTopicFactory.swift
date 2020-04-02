//
//  FirebaseTopicFactory.swift
//  Enrich_TMA
//
//  Created by Harshal on 02/04/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit
import FirebaseMessaging
import FirebaseAnalytics

class FirebaseTopicFactory {

    static let shared = FirebaseTopicFactory()

    func firebaseTopicSubscribe(employeeId: String, salonId: String){
        
        Messaging.messaging().subscribe(toTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.employee) + employeeId) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS EMPLOYEE: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.employee)")
            }
        }
        Messaging.messaging().subscribe(toTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.employeeAll)) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS ALL EMPLOYEES: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.employeeAll)")
            }
            
        }
        Messaging.messaging().subscribe(toTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.manager)) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS ALL MANAGERS: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.manager)")
            }
            
        }
        Messaging.messaging().subscribe(toTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.salon) + salonId) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS SALON: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.salon)")
            }
        }
    }
    
    
    func firebaseTopicUnSubscribe(employeeId: String, salonId: String){
        
        Messaging.messaging().unsubscribe(fromTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.employee) + employeeId) { error in
            if error != nil {
                print("FCM TOPIC UNSUBSCRIBE AS EMPLOYEE: \(error?.localizedDescription ?? "")")
            } else {
                print("UNSUBSCRIBED TO TOPIC \(FCMTopicKeys.employee)")
            }
        }
        Messaging.messaging().unsubscribe(fromTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.employeeAll)) { error in
            if error != nil {
                print("FCM TOPIC UNSUBSCRIBE AS ALL EMPLOYEES: \(error?.localizedDescription ?? "")")
            } else {
                print("UNSUBSCRIBED TO TOPIC \(FCMTopicKeys.employeeAll)")
            }
        }
        Messaging.messaging().unsubscribe(fromTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.manager)) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS ALL MANAGERS: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.manager)")
            }
            
        }
        Messaging.messaging().unsubscribe(fromTopic: GenericClass.sharedInstance.getFCMTopicKeys(keyFor: FCMTopicKeys.salon) + salonId) { error in
            if error != nil {
                print("FCM TOPIC SUBSCRIBE AS SALON: \(error?.localizedDescription ?? "")")
            } else {
                print("SUBSCRIBED TO TOPIC \(FCMTopicKeys.salon)")
            }
        }
    }
}
