//
//  ViewController.swift
//  Typist
//
//  Created by Toto Tvalavadze on 2016/09/26.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let keyboard = Typist.shared

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = UIView()
            tableView.tableFooterView = UIView()
        }
    }

    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var textField: UITextField!
    @IBOutlet var bottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // keyboard input accessory view support
        textField.inputAccessoryView = UIView(frame: toolbar.bounds)

        // keyboard frame observer
        keyboard
            .toolbar(scrollView: tableView)
            .on(event: .willChangeFrame) { [unowned self] options in
                let height = options.endFrame.height
                UIView.animate(withDuration: 0) {
                    self.bottom.constant = max(0, height - self.toolbar.bounds.height)
                    self.tableView.contentInset.bottom = max(self.toolbar.bounds.height, height)
                    self.tableView.scrollIndicatorInsets.bottom = max(self.toolbar.bounds.height, height)
                    self.toolbar.layoutIfNeeded()
                }
                self.navigationItem.prompt = options.endFrame.debugDescription
            }
            .on(event: .willHide) { [unowned self] options in
                // .willHide is used in cases when keyboard is *not* dismiss interactively.
                // e.g. when `.resignFirstResponder()` is called on textField.
                UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIViewAnimationOptions(curve: options.animationCurve), animations: {
                    self.bottom.constant = 0
                    self.tableView.contentInset.bottom = self.toolbar.bounds.height
                    self.tableView.scrollIndicatorInsets.bottom = self.toolbar.bounds.height
                    self.toolbar.layoutIfNeeded()
                }, completion: nil)
            }
            .start()

        navigationItem.prompt = "Keybaord frame will appear here."
        title = "Typist Demo"
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
    }
}
