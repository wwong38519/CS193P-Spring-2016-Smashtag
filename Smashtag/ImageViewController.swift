//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Winnie on 19/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
