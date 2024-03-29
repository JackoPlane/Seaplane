//  Copyright © 2018 SkeletonView. All rights reserved.

import SkeletonView
import UIKit

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.isSkeletonable = true
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false

            collectionView.dataSource = self
            collectionView.delegate = self

            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
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
        view.isSkeletonable = true
        collectionView.prepareSkeleton(completion: { _ in
            self.view.showAnimatedSkeleton()
        })
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

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

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3 - 10, height: view.frame.width / 3 - 10)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension ViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }

    func collectionSkeletonView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell
    }
}
