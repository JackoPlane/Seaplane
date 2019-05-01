//
//  AuthenticationLinkViewController.swift
//  Floatplane TV
//
//  Created by Jack Perry on 1/10/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Foundation
import UIKit
import Voucher

public class AuthenticationLinkViewController: UIViewController {
    var voucher: VoucherClient?

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startVoucherClient()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        voucher?.stop()
    }

    func startVoucherClient() {
        voucher = VoucherClient(uniqueSharedId: "floatplane")
        voucher!.startSearching { [unowned self] authData, _, _ in

            // (authData is of type NSData)
            if let authData = authData {
                // User granted permission on iOS app!

                let cookieValue = String(data: authData, encoding: .utf8)!
                print("Cookie value: \(cookieValue)")
                let httpCookie = HTTPCookie(properties: [
                    .version: 0,
                    .name: "sails.sid",
                    .value: cookieValue,
                    .expires: "2018-10-07 07:03:42 +0000",
                    .path: "/",
                    .domain: "www.floatplane.com",
                    .secure: true,
                ])

                if let cookie = httpCookie {
                    print("SETTING COOKIE!!!")
                    HTTPCookieStorage.shared.setCookie(cookie)
                    Alamofire.Session.default.sessionConfiguration.httpCookieStorage?.setCookie(cookie)

                    Alamofire.Session.default.session.configuration.httpCookieStorage?.setCookies(
                        [cookie],
                        for: URL(string: "https://www.floatplane.com/")!,
                        mainDocumentURL: nil
                    )
                }

                self.performSegue(withIdentifier: "success", sender: nil)
            } else {
                print("Failed")
            }
        }
    }
}
