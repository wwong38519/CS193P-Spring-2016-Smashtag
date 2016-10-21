//
//  WebViewController.swift
//  Smashtag
//
//  Created by Winnie on 21/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
            automaticallyAdjustsScrollViewInsets = false
            updateUI()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: NSURL? { didSet { updateUI() } }
    
    private var searchBar: UISearchBar?
    private var backButton: UIBarButtonItem?
    private var forwardButton: UIBarButtonItem?
    
    private func updateUI() {
        if url != nil {
            webView?.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar = UISearchBar()
        searchBar?.autocorrectionType = UITextAutocorrectionType.No
        searchBar?.autocapitalizationType = UITextAutocapitalizationType.None
//        searchBar?.userInteractionEnabled = false
        searchBar?.delegate = self
        
        let doneButton = UIBarButtonItem(title: Storyboard.DoneButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.done))
        backButton = UIBarButtonItem(title: Storyboard.BackButtonTitle, style: UIBarButtonItemStyle.Plain, target: webView, action: #selector(UIWebView.goBack))
        forwardButton = UIBarButtonItem(title: Storyboard.ForwardButtonTitle, style: UIBarButtonItemStyle.Plain, target: webView, action: #selector(UIWebView.goForward))
        backButton?.enabled = false
        forwardButton?.enabled = false
        
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItems = [forwardButton!, backButton!]
        self.navigationItem.titleView = searchBar
    }
    
    func done() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        backButton?.enabled = webView.canGoBack
        forwardButton?.enabled = webView.canGoForward
        searchBar?.text = webView.request?.URL?.absoluteString
        spinner.stopAnimating()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        url = NSURL(string: searchBar.text!)
    }
}
