//
//  AppDelegate.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit
import Firebase
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let commands = ["MorningTime","FormiddagTime","MiddagTime",
                    "EftermiddagTime","AftenTime","NatTime"]
    let times = ["06:00","10:00","12:00","16:00","18:00","22:00"]

    var eventstore: EKEventStore!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        eventstore = EKEventStore()
        
        // check if we have access to calendars, and create a calendar for the app.
        eventstore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                print("access granted")
                let newCalendar = EKCalendar(for: .reminder, eventStore: self.eventstore!)
                
                newCalendar.title = "MediCue Kalender"
                
                let sourcesInEventStore = self.eventstore.sources
                
                let filteredSources = sourcesInEventStore.filter { $0.sourceType == .local }
                
                if let localSource = filteredSources.first {
                    newCalendar.source = localSource
                } else {
                    print("local source was nil")
                    newCalendar.source = self.eventstore.defaultCalendarForNewReminders()?.source
                }
    
                var exists = false
                let cals = self.eventstore.calendars(for: .reminder)
                for c in cals{
                    if let id = UserDefaults.standard.string(forKey: "MediCuePrimaryCalendar"){
                        if c.calendarIdentifier == id{
                            print("We already had a calendar")
                            exists = true
                        }
                    }
                }
                if !exists{
                do {
                    try self.eventstore.saveCalendar(newCalendar, commit: true)
                    UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "MediCuePrimaryCalendar")
                }
                catch{
                    print(error)
                    }}
                
            } else {
                print(error!)
            }
        }
        print("Done!")
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

