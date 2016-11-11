//
//  WebViewController.swift
//  Trainsweet
//
//  Created by Scott Richards on 10/16/16.
//  Copyright © 2016 Ricky Reed. All rights reserved.
//

import UIKit
import WebKit

class TSWebViewController: UIViewController, WKNavigationDelegate {
    var webView : WKWebView?
    var url : URL?
    var navTitle : String?
    var activityIndicator : UIActivityIndicatorView?
    
    convenience init(url:String, title : String) {
        self.init()
        self.url = URL(string:url)
        self.navTitle = title
    }
//    override func loadView() {
//        super.loadView()
//        self.webView = WKWebView()
//        self.view = self.webView
//    }
    
    // add spinner to indicate network activity while requesting data feed
    func addActivityIndicator() {
        if let activityIndicator = activityIndicator {
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }

    func removeActivityIndicator() {
        if let activityIndicator = activityIndicator {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView?.navigationDelegate = self
        self.view = webView
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        navigationBar.tintColor = UIColor.whiteColor()
        if let url = url {
            let req = URLRequest(url: url)
            self.webView!.load(req)
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        }
        self.navigationItem.title = navTitle
        // Do any additional setup after loading the view.
    }

    // add activity indicator here the view center is not set up yet in viewDidLoad
    override func viewDidLayoutSubviews() {
         addActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeActivityIndicator()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
