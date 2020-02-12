//
//  ExtensionAppDelegate.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 13/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

extension AppDelegate {

    func navigationbackButtonBehaviour() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: FontName.FuturaPTMedium.rawValue, size: is_iPAD ? 26.0 : 20.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let barButtonItemAppearance = UIBarButtonItem.appearance()

        barButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
        barButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)

        // Sets Navigation bar Title Color and Font

        let attrs = [

            NSAttributedString.Key.foregroundColor: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: FontName.FuturaPTMedium.rawValue, size: is_iPAD ? 26.0 : 20.0)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs

        // Sets Navigation Back Button Color
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true

    }

    func tabBarAppearace() {
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont(name: FontName.FuturaPTMedium.rawValue, size: 13)!],
                for: .normal)
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont(name: FontName.FuturaPTMedium.rawValue, size: 13)!],
                for: .selected)
    }
    // MARK: Move To Landing Screen
    func moveToLandingScreen() {
        // authentication successful

        self.window?.rootViewController = customTabbarController
        self.window?.makeKeyAndVisible()
    }

}

extension AppDelegate {

    // Logout Flow

    func signOutUserFromApp() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn)
        userDefaults.removeObject(forKey: UserDefauiltsKeys.k_Key_LoginUser)
        userDefaults.synchronize()
        let navigationC = LoginNavigtionController.instantiate(fromAppStoryboard: .Login)
        self.window?.rootViewController = navigationC
    }

    func openGoogleMaps(lat: Double, long: Double) {

        if let UrlNavigation = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation) {
                if let urlDestination = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    //UIApplication.shared.openURL(urlDestination)
                    UIApplication.shared.open(urlDestination, options: [:])
                }
            } else {
                NSLog("Can't use comgooglemaps://")
                if let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination, options: [:])
                }

            }
        } else {
            NSLog("Can't use comgooglemaps://")
            if let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination, options: [:])
            }
        }

    }
}
