//
//  NotificationMaker.swift
//  MediCue
//
//  Created by Mads Østergaard on 18/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationMaker{
    let center = UNUserNotificationCenter.current()
    
    func createNotification(title: String, subtitle: String, body: String, categoryIdentifier: String, identifier: String, trigger: UNNotificationTrigger){
        
        let content = UNMutableNotificationContent()
        content.title = title
        if !subtitle.isEmpty{
        content.subtitle = subtitle
        }
        content.body = body
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = categoryIdentifier
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func removeNotification(identifier: [String]){
        center.removePendingNotificationRequests(withIdentifiers: identifier)
    }
}
