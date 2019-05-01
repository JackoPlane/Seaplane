//
//  UITableView+CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

extension UITableView: CollectionSkeleton {
    var estimatedNumberOfRows: Int {
        return Int(ceil(frame.height / rowHeight))
    }

    var skeletonDataSource: SkeletonCollectionDataSource? {
        get { return objc_getAssociatedObject(self, &CollectionAssociatedKeys.dummyDataSource) as? SkeletonCollectionDataSource }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.dummyDataSource, newValue, AssociationPolicy.retain.objc)
            dataSource = newValue
        }
    }

    var skeletonDelegate: SkeletonCollectionDelegate? {
        get { return objc_getAssociatedObject(self, &CollectionAssociatedKeys.dummyDelegate) as? SkeletonCollectionDelegate }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.dummyDelegate, newValue, AssociationPolicy.retain.objc)
            delegate = newValue
        }
    }

    func addDummyDataSource() {
        guard let originalDataSource = self.dataSource as? SkeletonTableViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
        else { return }
        let dataSource = SkeletonCollectionDataSource(tableViewDataSource: originalDataSource, rowHeight: calculateRowHeight())
        skeletonDataSource = dataSource
        reloadData()
    }

    func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        restoreRowHeight()
        skeletonDataSource = nil
        self.dataSource = dataSource.originalTableViewDataSource
        if reloadAfter { reloadData() }
    }

    private func restoreRowHeight() {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        rowHeight = dataSource.rowHeight
    }

    private func calculateRowHeight() -> CGFloat {
        guard rowHeight == UITableView.automaticDimension else { return rowHeight }
        rowHeight = estimatedRowHeight
        return estimatedRowHeight
    }
}
