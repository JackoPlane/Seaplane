//
//  FeedViewController.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import AVKit
import Foundation
import Kingfisher
import MediaPlayer
import UIKit
import Voucher

#if os(iOS)
    import SkeletonView
#endif

public class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    /// Subscriptions
    public var subscriptions: Subscriptions?

    /// Videos
    public var videos: Videos?

    
    // MARK: - Lifecycle
    // ------------------------------------------------------------------------------

    public override func loadView() {
        super.loadView()

        #if os(iOS)
            (UIApplication.shared.delegate as? AppDelegate)?.startVoucherServer()
        #endif

        // Navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        #if os(iOS)
            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
            loadingView.tintColor = .white

            collectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
                // Add your logic here
                // Do not forget to call dg_stopLoading() at the end
                self?.collectionView.dg_stopLoading()
            }, loadingView: loadingView)
            collectionView.dg_setPullToRefreshFillColor(UIColor(named: "floatplane-primary-blue")!)
            collectionView.dg_setPullToRefreshBackgroundColor(collectionView.backgroundColor ?? .white)
        #endif
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
            collectionView.prepareSkeleton(completion: { _ in
                self.view.showAnimatedGradientSkeleton()
            })
        #endif
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setupNavigationBar()

        // Load subscriptions
        loadSubscriptions {
            self.loadVideos(creators: self.subscriptions?.compactMap { $0 }.compactMap { $0.creator }.unique() ?? [], {
                DispatchQueue.main.async {
                    #if os(iOS)
                        self.view.hideSkeleton()
                    #endif

                    self.collectionView.reloadData()
                }

            })
        }
    }

    // MARK: - Orientation support
    // ------------------------------------------------------------------------------

    #if os(iOS)
        public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .portrait
            } else {
                return .all
            }
        }
    #endif

    
    // MARK: - Loading
    // ------------------------------------------------------------------------------

    internal func loadSubscriptions(_ completion: (() -> Void)? = nil) {
        Subscriptions.load { subscriptions in
            self.subscriptions = subscriptions

            // Now, we need to load `Creator`s (For name + thumbnail image)
            Creator.load { _ in
                completion?()
            }
        }
    }

    internal func loadVideos(creators: [String], _ completion: (() -> Void)? = nil) {
        Videos.load(creators: creators) { videos in
            self.videos = videos?.sorted(by: { $0.releaseDate > $1.releaseDate })

            completion?()
        }
    }

    
    // MARK: - Collection View data source
    // ------------------------------------------------------------------------------

    public override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return videos?.count ?? 0
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video-cell", for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }

        // Configure cell
        let video = videos?[indexPath.row]
        cell.creatorTitleLabel?.text = video?.creator
        cell.titleLabel?.text = video?.title

        if let urlString = video?.thumbnailUrl, let url = URL(string: urlString) {
            cell.thumbnailImageView?.kf.setImage(with: url)
        }

        if let creatorIdentifier = video?.creator, let creator = Creator.find(identifier: creatorIdentifier) {
            cell.creatorTitleLabel?.text = creator.title

            if let urlString = creator.icon?.path, let url = URL(string: urlString) {
                cell.creatorImageView?.kf.setImage(with: url)
            }
        }

        return cell
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #if os(iOS)
            if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell {
                cell.handleLongPressBegan()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    cell.handleLongPressEnded()
                }
            }
        #endif

        let video = videos?[indexPath.row]
        video?.getURL { urlString in
            guard let urlString = urlString else { return }

            let player = AVPlayer(url: URL(string: urlString)!)
            let playerViewController = LandscapeAVPlayerController()
            playerViewController.player = player
            self.present(playerViewController, animated: true)

            player.play()
        }
    }

    
    // MARK: - Collection View layout
    // ------------------------------------------------------------------------------

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

    public func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        var columns: CGFloat = 0
        let spacing: CGFloat = 10
        let aspectRatio: (CGFloat, CGFloat) = (7, 4) // I.e. 7:4 aspect ratio

        #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad { // iPad Support
                columns = UIDevice.current.orientation.isLandscape ? 3 : 2
            } else if UIDevice.current.userInterfaceIdiom == .phone { // iPhone Support
                // NOTE: Landscape only supoorted on "Plus" or "Max" devices. @see Supported Orientations
                columns = UIDevice.current.orientation.isLandscape ? 2 : 1
            }
        #elseif os(tvOS)
            columns = 3
        #endif

        // Safe Area inset support in landscape mode.. (iPhone X and later devices)
        let safeAreaInset: CGFloat = view.safeAreaInsets.left + view.safeAreaInsets.right

        // Calculate width + height based on columns, spacing and aspect ratio
        let width = ((collectionView.bounds.size.width - safeAreaInset) - (spacing * (columns + 1))) / columns
        let height = (width / aspectRatio.0) * aspectRatio.1

        return CGSize(width: width, height: height)
    }
}

#if os(iOS)
    extension FeedViewController: SkeletonCollectionViewDataSource {
        
        // MARK: - Skeleton View layout
        // ------------------------------------------------------------------------------

        public func collectionSkeletonView(_: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
            return "video-cell"
        }

        public func numSections(in _: UICollectionView) -> Int {
            return 1
        }

        public func collectionSkeletonView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
            return 10
        }
    }
#endif
