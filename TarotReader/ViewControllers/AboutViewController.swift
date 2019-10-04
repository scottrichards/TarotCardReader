//
//  AboutViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 11/4/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // clear out the back button navigation item
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor(netHex: Constants.Colors.MainBackground)
        let tapToGoBack = UITapGestureRecognizer(target: self, action: #selector(self.returnToMainView(_:)))
        self.view.addGestureRecognizer(tapToGoBack)
    }

    @objc func returnToMainView(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------------
    // MARK: Actions
    // ------------------------------------

    @IBAction func onBuyClick(_ sender: AnyObject) {
        let advancedWebView = TSWebViewController(url:"https://toshasilver.com/pages/the-change-me-prayers-oracle-deck",title:"Oracle Deck")
        self.navigationController?.pushViewController(advancedWebView, animated: true)
    }

    @IBAction func onAboutClick(_ sender: AnyObject) {
    }
    
    
}
