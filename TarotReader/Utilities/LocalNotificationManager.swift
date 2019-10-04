//
//  LocalNotificationManager.swift
//  TarotReader
//
//  Created by Scott Richards on 3/6/17.
//  Copyright © 2017 Scott Richards. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationManager: NSObject {
    static let SecondsInDay = 86400
    
    class func grantPermissions() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
    
    class func scheduleLocalNotifications() {
        grantPermissions()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default
        
        let date = Date(timeIntervalSinceNow: 3600)
        
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })

    }
}
