//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by Winnie on 22/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

//private let reuseIdentifier = "Cell"

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

    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    */
    
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
    
    /*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
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
