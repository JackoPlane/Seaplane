//
//  ViewController.swift
//  SkeletonViewExample
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import SkeletonView
import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableview: UITableView! {
        didSet {
            tableview.rowHeight = UITableView.automaticDimension
            tableview.estimatedRowHeight = 120.0
        }
    }

    @IBOutlet var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
            avatarImage.layer.masksToBounds = true
        }
    }

    @IBOutlet var colorSelectedView: UIView! {
        didSet {
            colorSelectedView.layer.cornerRadius = 5
            colorSelectedView.layer.masksToBounds = true
            colorSelectedView.backgroundColor = SkeletonAppearance.default.tintColor
        }
    }

    @IBOutlet var switchAnimated: UISwitch!
    @IBOutlet var skeletonTypeSelector: UISegmentedControl!

    var type: SkeletonType {
        return skeletonTypeSelector.selectedSegmentIndex == 0 ? .solid : .gradient
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.isSkeletonable = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.showAnimatedSkeleton()
    }

    @IBAction func changeAnimated(_: Any) {
        if switchAnimated.isOn {
            view.startSkeletonAnimation()
        } else {
            view.stopSkeletonAnimation()
        }
    }

    @IBAction func changeSkeletonType(_: Any) {
        refreshSkeleton()
    }

    @IBAction func btnChangeColorTouchUpInside(_: Any) {
        showAlertPicker()
    }

    func refreshSkeleton() {
        view.hideSkeleton()
        if type == .gradient { showGradientSkeleton() }
        else { showSolidSkeleton() }
    }

    func showSolidSkeleton() {
        if switchAnimated.isOn {
            view.showAnimatedSkeleton(usingColor: colorSelectedView.backgroundColor!)
        } else {
            view.showSkeleton(usingColor: colorSelectedView.backgroundColor!)
        }
    }

    func showGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: colorSelectedView.backgroundColor!)
        if switchAnimated.isOn {
            view.showAnimatedGradientSkeleton(usingGradient: gradient)
        } else {
            view.showGradientSkeleton(usingGradient: gradient)
        }
    }

    func showAlertPicker() {
        let alertView = UIAlertController(title: "Select color", message: "\n\n\n\n\n\n", preferredStyle: .alert)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self

        alertView.view.addSubview(pickerView)

        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0)
            self.colorSelectedView.backgroundColor = colors[row].0
            self.refreshSkeleton()
        }
        alertView.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)

        present(alertView, animated: false, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return colors.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return colors[row].1
    }
}

extension ViewController: SkeletonTableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 9
    }

    func collectionSkeletonView(_: UITableView, cellIdentifierForRowAt _: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! Cell
        cell.label1.text = "cell => \(indexPath.row)"
        return cell
    }
}
