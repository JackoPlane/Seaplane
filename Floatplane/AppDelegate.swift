//
//  AppDelegate.swift
//  Floatplane
//
//  Created by Jack Perry on 17/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import BLTNBoard
import UIKit
import Voucher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    /// Window
    var window: UIWindow?

    /// Voucher server, used for cred share with tvOS
    fileprivate var voucherServer: VoucherServer?

    fileprivate var bulletinManager: BLTNItemManager?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - tvOS Credentials sharing

    /// -----------------------------------------------------------------------------------------------

    public func startVoucherServer() {
        voucherServer = VoucherServer(uniqueSharedId: "Floatplane")
        voucherServer?.startAdvertising { (displayName, responseHandler) -> Void in

//            let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
//                responseHandler(nil, nil)
//            }))
//
//            alertController.addAction(UIAlertAction(title: "Allow", style: .default, handler: { action in
//                let token = UserDefaults.standard.string(forKey: "sails.sid") ?? "THIS IS AN AUTH TOKEN"
//                let authData = token.data(using: .utf8)!
//                responseHandler(authData, nil)
//            }))
//

            let page = BLTNPageItem(title: "Share Account")
            page.image = UIImage(named: "bulletin-icon-tv")

            page.descriptionText = "\"\(displayName)\" would like to use your credentials for Floatplane. Do you want to send the credentials for Floatplane?"
            page.actionButtonTitle = "Send Account"
            page.actionHandler = { (_: BLTNActionItem) in
                print("Action button tapped")

                let token = UserDefaults.standard.string(forKey: "sails.sid") ?? ""
                let authData = token.data(using: .utf8)!
                responseHandler(authData, nil)

                self.bulletinManager?.dismissBulletin()
                self.bulletinManager = nil // Reset
            }

            // Appearance
            page.appearance.actionButtonColor = UIColor(red: 212.0 / 255.0, green: 211.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
            page.appearance.actionButtonTitleColor = UIColor(red: 77.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
            page.appearance.titleTextColor = UIColor(red: 77.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)

            self.bulletinManager = BLTNItemManager(rootItem: page)
            if let viewController = self.window?.rootViewController {
                self.bulletinManager?.showBulletin(above: viewController)
            }
        }
    }

    public func stopVoucherServer() {
        voucherServer?.stop()
    }
}
