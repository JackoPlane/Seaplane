//
//  ViewController.swift
//  Voucher iOS App
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit
import Voucher

class ViewController: UIViewController, VoucherServerDelegate {
    var server: VoucherServer?

    @IBOutlet var serverStatusLabel: UILabel!
    @IBOutlet var connectionStatusLabel: UILabel!

    deinit {
        self.server?.stop()
        self.server?.delegate = nil
        self.server = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let uniqueId = "VoucherTest"
        server = VoucherServer(uniqueSharedId: uniqueId)
        server?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        server?.startAdvertising { (displayName, responseHandler) -> Void in

            let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { _ in
                responseHandler(nil, nil)
            }))

            alertController.addAction(UIAlertAction(title: "Allow", style: .default, handler: { _ in
                // For our authData, use a token string (to simulate an OAuth token, for example)
                let authData = "THIS IS AN AUTH TOKEN".data(using: String.Encoding.utf8)!
                responseHandler(authData, nil)
            }))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        server?.stop()
    }

    // MARK: - VoucherServerDelegate

    func voucherServer(_: VoucherServer, didUpdateAdvertising isAdvertising: Bool) {
        var text = "❌ Server Offline."
        if isAdvertising {
            text = "✅ Server Online."
        }
        serverStatusLabel.text = text
        connectionStatusLabel.isHidden = !isAdvertising
    }

    func voucherServer(_: VoucherServer, didUpdateConnectionToClient isConnectedToClient: Bool) {
        var text = "📡 Waiting for Connection..."
        if isConnectedToClient {
            text = "✅ Connected."
        }
        connectionStatusLabel.text = text
    }
}
