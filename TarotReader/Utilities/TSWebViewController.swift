//
//  WebViewController.swift
//  Trainsweet
//
//  Created by Scott Richards on 10/16/16.
//  Copyright © 2016 Ricky Reed. All rights reserved.
//

import UIKit
import WebKit

class TSWebViewController: UIViewController {
    var webView : WKWebView?
    var url : URL?
    var navTitle : String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        self.view = webView
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        navigationBar.tintColor = UIColor.whiteColor()
        if let url = url {
            let req = URLRequest(url: url)
            self.webView!.load(req)
        }
        self.navigationItem.title = navTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
