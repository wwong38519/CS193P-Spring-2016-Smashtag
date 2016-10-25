//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by Winnie on 22/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Model
    
    var tweetMedia = [Array<(Twitter.Tweet, Twitter.MediaItem)>]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweetMedia.removeAll()
            lastTwitterRequest = nil
            searchForImages()
            navigationItem.title = searchText
            Truth.add(searchText!)
        }
    }

    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if var query = searchText where !query.isEmpty {
                if query[query.startIndex] == "@" {
                    query +=  " OR from:"+query.substringFromIndex(query.startIndex.advancedBy(1))
                }
                return Twitter.Request(search: query + " filter:media -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForImages() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweetMedia.insert(newTweets.map{ tweet in tweet.media.map{ (tweet, $0) } }.flatMap{ $0 }, atIndex: 0)
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(ImageCollectionViewController.pinch)))
    }
    
    func pinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            area *= Double(recognizer.scale)
            recognizer.scale = 1.0
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return tweetMedia.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetMedia[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.ImageCollectionCellIdentifier, forIndexPath: indexPath)
        let item = tweetMedia[indexPath.section][indexPath.row]
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.tweetMedia = item
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let (_, media) = tweetMedia[indexPath.section][indexPath.row]
        /*
         w / h = s
         w = h * s or h = w / s
         w * h = a
         h*s*h = a or w*w/s = a
         h = sqrt(a / s)
         w = sqrt(a * s)
         */
        let width = sqrt(area * media.aspectRatio)
        let height = area / width
        return CGSize(width: width, height: height)
    }
    
    private var area = 10000.0 {
        didSet {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowSearchSegueIdentifier:
                if let tweetvc = destinationvc as? TweetTableViewController, imageCell = sender as? ImageCollectionViewCell {
                    if let (tweet, _) = imageCell.tweetMedia {
                        tweetvc.tweets = [[tweet]]
                    }
                }
            default:
                break
            }
        }
    }
}
