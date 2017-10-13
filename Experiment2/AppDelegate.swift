//
//  AppDelegate.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = FeatureLauncher.launchFeature()
        return true
    }
}

