//
//  InstructionsViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 11/3/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    @IBOutlet weak var instructionsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsView.setContentOffset(CGPoint.zero, animated: false)
        instructionsView.isScrollEnabled = true
        instructionsView.flashScrollIndicators()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        instructionsView.setContentOffset(CGPoint.zero, animated: false)
    }


}
