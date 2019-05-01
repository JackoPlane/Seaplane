//
//  RootViewController.swift
//  Voucher
//
//  Created by Rizwan Sattar on 11/9/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, AuthViewControllerDelegate {
    var isAuthenticated: Bool = false {
        didSet {
            authenticationUI.isHidden = isAuthenticated
            clearAuthenticationButton.isHidden = !isAuthenticated
            if isAuthenticated {
                authenticationLabel.text = "Authenticated!"
            } else {
                authenticationLabel.text = "Not Authenticated"
            }
            view.setNeedsLayout()
        }
    }

    @IBOutlet var authenticationLabel: UILabel!
    @IBOutlet var clearAuthenticationButton: UIButton!
    @IBOutlet var authenticationUI: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        isAuthenticated = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let segueIdentifier = segue.identifier else {
            return
        }

        if segueIdentifier == "showVoucher" {
            let viewController = segue.destination as! AuthViewController
            viewController.delegate = self
        }
    }

    @IBAction func onClearDataTriggered(_: UIButton) {
        isAuthenticated = false
    }

    // MARK: - AuthViewControllerDelegate

    func authController(_: AuthViewController, didSucceed succeeded: Bool) {
        isAuthenticated = succeeded
        dismiss(animated: true, completion: nil)
    }
}
