//
//  TSEmailController.swift
//  Trainsweet
//
//  Created by Scott Richards on 10/16/16.
//  Copyright © 2016 Ricky Reed. All rights reserved.
//

import UIKit
import MessageUI

class EmailComposer: NSObject, MFMailComposeViewControllerDelegate {

        
    
//    func contents() -> String {
//        
//    }
    
    // Did this in order to mitigate needing to import MessageUI in my View Controller
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func configuredMailComposeViewController(imageName : String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self

        if let image = UIImage(named: imageName) {
            mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "changeprayer.jpeg")
        }
        
        mailComposerVC.setMessageBody("<html><body><p>Tosha Silver’s Change Me Prayer Oracle App provided me with this message from The Divine 😀</p></body></html>", isHTML: true)
        
        mailComposerVC.setSubject("Change Me Prayers")

        return mailComposerVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}


