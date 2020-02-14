//
//  ApplicationFactory.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 13/02/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class ApplicationFactory {

    static let shared = ApplicationFactory()

    func openGoogleMaps(lat: Double, long: Double) {

        if let UrlNavigation = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation) {
                if let urlDestination = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    //UIApplication.shared.openURL(urlDestination)
                    UIApplication.shared.open(urlDestination, options: [:])
                }
            }
            else {
                NSLog("Can't use comgooglemaps://")
                if let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination, options: [:])
                }

            }
        }
        else {
            NSLog("Can't use comgooglemaps://")
            if let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination, options: [:])
            }
        }

    }

}
