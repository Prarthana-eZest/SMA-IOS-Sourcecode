//
//  ExtensionAppDelegate.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 13/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

extension AppDelegate {

    // MARK: Move To Landing Screen
    func moveToLandingScreen() {
        // authentication successful
        self.window?.rootViewController = customTabbarController
        self.window?.makeKeyAndVisible()
    }

}
