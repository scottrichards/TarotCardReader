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

        
//    func feedbackContent() -> String {
//            let feedbackContent = NSMutableString()
//            feedbackContent.appendString("<br /><div style=\"width:80%;margin:10px 5% 10px 5%;padding:10px 5% 10px 5%;height:auto;border: 1px #cccccc solid;background-color:#efefef\">")
//            feedbackContent.appendString("<strong>" + StringUtilities.getLocalizedString(stringKey: "more.feedback.deviceName") + "</strong> \(UIDevice.currentDevice().model)<br />")
//            feedbackContent.appendString("<strong>" + StringUtilities.getLocalizedString(stringKey: "more.feedback.systemVersion") + "</strong> \(UIDevice.currentDevice().systemVersion)<br />")
//            
//            let appName = appInfoWithKey("CFBundleName")!
//            let appVersion = appInfoWithKey("CFBundleShortVersionString")!
//            let appBuildNumber = appInfoWithKey("CFBundleVersion")!
//            let appVersionString = "\(appVersion) (\(appBuildNumber))"
//            
//            feedbackContent.appendString("<strong>" + StringUtilities.getLocalizedString(stringKey: "more.feedback.appName") + "</strong> \(appName)<br />")
//            feedbackContent.appendString("<strong>" + StringUtilities.getLocalizedString(stringKey: "more.feedback.appVersion") + "</strong> \(appVersionString)<br />")
//            return String(feedbackContent)
//    }
    
    // Did this in order to mitigate needing to import MessageUI in my View Controller
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
 //       mailComposerVC.setToRecipients(["sean@trainsweet.com"])
        mailComposerVC.setSubject("Change Me Prayers")
        mailComposerVC.setMessageBody(StringUtilities.getLocalizedString(stringKey: Constants.Strings.EMail.Body), isHTML: false)
//        mailComposerVC.navigationBar.backgroundColor = UIColor.trainsweetGreen()
//        mailComposerVC.navigationController?.navigationBar.barTintColor = UIColor.trainsweetGreen()
//        mailComposerVC.navigationBar.barTintColor = UIColor.greenColor()
//        UINavigationBar.appearance().tintColor = UIColor.greenColor()
//        UINavigationBar.appearance().backgroundColor = UIColor.greenColor()

//        mailComposerVC.navigationBar.tintColor = UIColor.whiteColor()
//        mailComposerVC.navigationBar.backItem?.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        //backBarButtonItem?.tintColor = UIColor.whiteColor()
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


