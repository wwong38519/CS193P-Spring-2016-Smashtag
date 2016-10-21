//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Winnie on 19/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Navigation

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = ImageZoom.MinScale
            scrollView.maximumZoomScale = ImageZoom.MaxScale
            scrollView.addSubview(imageView)
            automaticallyAdjustsScrollViewInsets = false    // to remove "whitespace" in scrollView
        }
    }
    
    private var imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            scrollView?.contentSize = image!.size
        }
    }
    
    
}
