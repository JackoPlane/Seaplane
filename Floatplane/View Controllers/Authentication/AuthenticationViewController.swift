//
//  AuthenticationViewController.swift
//  The Louvre
//
//  Created by Jack Perry on 19/7/17.
//  Copyright © 2017 World Nomads Group. All rights reserved.
//

import Foundation
import TKSubmitButtons
import Typist
import UIKit

class AuthenticationViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private let keyboard = Typist.shared

    @IBOutlet var logoFrame: UIView!
    @IBOutlet var textFieldFrame: UIView!

    @IBOutlet var loginButton: TKTransitionSubmitButton!
    @IBOutlet var usernameTextField: AwesomeTextField!
    @IBOutlet var passwordTextField: AwesomeTextField!

    @IBOutlet var logoFrameTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var textAreaYLayoutConstraint: NSLayoutConstraint!

    
    // MARK: - View life
    /// ---------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        prerpareForAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareKeyboardSupport()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Update center Y position based on safe area
        textAreaYLayoutConstraint.constant = (35 + (view.safeAreaInsets.bottom / 2)) * -1

        // Adds support for "fast login" for debugging purposes
        #if DEBUG
            self.view.isUserInteractionEnabled = false // Disable interactions to prevent "double" logins
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
                self?.login()
                self?.view.isUserInteractionEnabled = false
            })
        #endif
        
        
        // Animate!
        usernameTextField.becomeFirstResponder()
        
    }

    
    /// Keyboard
    /// -----------------------------------------------------------------------------------------------

    func prepareKeyboardSupport() {
        keyboard
            .on(event: .willShow) { options in
                self.animate(options)
            }.on(event: .willChangeFrame) { options in
                self.animate(options)
            }.on(event: .willHide) { options in
                self.animate(options)
            }
            .start()
    }

    /// Animations
    /// -----------------------------------------------------------------------------------------------

    func prerpareForAnimation() {
        textFieldFrame.alpha = 0
        textFieldFrame.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        logoFrameTopLayoutConstraint.constant = (view.bounds.size.height - logoFrame.frame.size.height) / 2
        view.layoutIfNeeded()

        // Double check we don't have a keyboard visible
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    public func animate(_ options: Typist.KeyboardOptions) {
        let textAreaHeight: CGFloat = 120

        var remainingViewHeight = view.bounds.height
        if options.endFrame.origin.y != view.bounds.height {
            remainingViewHeight = view.bounds.size.height - options.endFrame.height
        }
        let logoTopLayoutConstraint = (remainingViewHeight - (logoFrame.frame.size.height + textAreaHeight + 15)) / 2

        // Update the text area frame first
        textAreaYLayoutConstraint.constant = logoTopLayoutConstraint + logoFrame.frame.size.height + 15
        view.layoutIfNeeded()

        // Update the logo frame constraint now
        logoFrameTopLayoutConstraint.constant = logoTopLayoutConstraint

        // Logo Frame
        UIView.animate(withDuration: options.animationDuration, delay: 0, options: [.beginFromCurrentState, UIView.AnimationOptions(curve: options.animationCurve)], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

        // Text Area Frame
        UIView.animate(withDuration: options.animationDuration - (options.animationDuration / 3), delay: options.animationDuration / 3, options: [UIView.AnimationOptions(curve: options.animationCurve)], animations: {
            self.textFieldFrame.alpha = 1.0
            self.textFieldFrame.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    /// Actions
    /// -----------------------------------------------------------------------------------------------

    @IBAction func login(_: Any? = nil) {
        guard let emailAddress = self.usernameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        // Hide the keyboard
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        // Start the loading indicator
        loginButton.startLoadingAnimation()

        // Attempt to login
        Account.login(username: emailAddress, password: password) { (result: Result<Account, Error>) in
            
            switch result {
            case .failure(let error):
                print("Login error: \(error)")
                
            case .success(let account):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainNavigtionController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
                
                DispatchQueue.main.async {
                    self.loginButton.startFinishAnimation(0) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                            mainNavigtionController.transitioningDelegate = self
                            
                            UIApplication.shared.keyWindow?.rootViewController = mainNavigtionController
                        }
                    }
                }
            }
            
        
    
//            self.performSegue(withIdentifier: "success", sender: nil)
        }
    }

    func requestNewPassword() {
//        let prompt = CDAlertView(title: "Welcome to the Louvre!", message: "Lets get you set up, first; enter a new password", type: .notification)
//        prompt.isTextFieldHidden = false
//
//        let action = CDAlertViewAction(title: "Save", handler: { action in
//            self.updatePassword(prompt.textFieldText ?? "password")
//        })
//        prompt.add(action: action)
//        prompt.show()
//
    }

    func updatePassword(_: String) {
//        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
//            print("Error: \(error)")
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainNavigtionController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
//
//            DispatchQueue.main.async {
//                self.loginButton.startFinishAnimation(0) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
//                        mainNavigtionController.transitioningDelegate = self
//                        UIApplication.shared.keyWindow?.rootViewController = mainNavigtionController
//                    })
//                }
//            }
//        }
    }

    // MARK: - Transition Delegate

    /// -----------------------------------------------------------------------------------------------

    func animationControllerForPresentedController(presented _: UIViewController, presentingController _: UIViewController, sourceController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }

    func animationControllerForDismissedController(dismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

public extension UIView.AnimationOptions {
    init(curve: UIView.AnimationCurve) {
        switch curve {
            case .easeIn:
                self = [.curveEaseIn]
            case .easeOut:
                self = [.curveEaseOut]
            case .easeInOut:
                self = [.curveEaseInOut]
            case .linear:
                self = [.curveLinear]
            default:
                self = [.curveLinear]
        }
    }
}
