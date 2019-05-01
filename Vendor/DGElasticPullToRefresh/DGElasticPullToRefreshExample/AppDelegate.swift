//
//  AppDelegate.swift
//  DGElasticPullToRefreshExample
//
//  Created by Danil Gontovnik on 10/2/15.
//  Copyright © 2015 Danil Gontovnik. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_: UIApplication) {
        let viewController = ViewController()
        let navigationController = NavigationController(rootViewController: viewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigationController
        window!.backgroundColor = .white
        window!.makeKeyAndVisible()
    }
}
