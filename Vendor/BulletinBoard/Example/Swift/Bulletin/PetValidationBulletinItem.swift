/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import BLTNBoard
import UIKit

/**
 * A bulletin page that allows the user to validate its selection.
 *
 * This item demonstrates popping to the previous item, and including a collection view inside the page.
 */

class PetValidationBLTNItem: FeedbackPageBLTNItem {
    let dataSource: CollectionDataSource
    let animalType: String

    let selectionFeedbackGenerator = SelectionFeedbackGenerator()
    let successFeedbackGenerator = SuccessFeedbackGenerator()

    init(dataSource: CollectionDataSource, animalType: String) {
        self.dataSource = dataSource
        self.animalType = animalType
        super.init(title: "Choose your Favorite")

        isDismissable = false
        descriptionText = "You chose \(animalType) as your favorite animal type. Here are a few examples of posts in this category."
        actionButtonTitle = "Validate"
        alternativeButtonTitle = "Change"
    }

    // MARK: - Interface

    var collectionView: UICollectionView?

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white

        let collectionWrapper = interfaceBuilder.wrapView(collectionView, width: nil, height: 256, position: .pinnedToEdges)

        self.collectionView = collectionView
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self

        return [collectionWrapper]
    }

    override func tearDown() {
        super.tearDown()
        collectionView?.dataSource = nil
        collectionView?.delegate = nil
    }

    // MARK: - Touch Events

    override func actionButtonTapped(sender _: UIButton) {
        // > Play Haptic Feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // > Display the loading indicator

        manager?.displayActivityIndicator()

        // > Wait for a "task" to complete before displaying the next item

        let delay = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delay) {
            // Play success haptic feedback

            self.successFeedbackGenerator.prepare()
            self.successFeedbackGenerator.success()

            // Display next item

            self.next = BulletinDataSource.makeCompletionPage()
            self.manager?.displayNextItem()
        }
    }

    override func alternativeButtonTapped(sender _: UIButton) {
        // Play selection haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Display previous item

        manager?.popItem()
    }
}

// MARK: - Collection View

extension PetValidationBLTNItem: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = dataSource.image(at: indexPath.row)
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let squareSideLength = (collectionView.frame.width / 3) - 3
        return CGSize(width: squareSideLength, height: squareSideLength)
    }
}
