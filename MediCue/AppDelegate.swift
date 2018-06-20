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
import UserNotifications
import EstimoteProximitySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTTriggerManagerDelegate {

    var window: UIWindow?
    let commands = ["MorningTime","FormiddagTime","MiddagTime",
                    "EftermiddagTime","AftenTime","NatTime"]
    let times = ["06:00","10:00","12:00","16:00","18:00","22:00"]

    //var eventstore: EKEventStore!
    let triggerManager = ESTTriggerManager()
    var ref: DatabaseReference!
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    let notificationCenterDelegate = NotificationDelegate()
    let notificationMaker = NotificationMaker()
    var proximityZones = [EPXProximityZone]()
    var proximityObserver: EPXProximityObserver?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup needed resources:
        // - Firebase:
        FirebaseApp.configure()
        
        // - UserNotifications
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.delegate = notificationCenterDelegate
        
        // - Estimote Beacons
        //ESTConfig.setupAppID("medicue-0jx", andAppToken: "4667a2c1dfc99ea7faacf037bb54cb4f")
        let cloudCredentials = EPXCloudCredentials(appID: "medicue-0jx", appToken: "4667a2c1dfc99ea7faacf037bb54cb4f")
        proximityObserver = EPXProximityObserver(credentials: cloudCredentials, errorBlock: { error in
            print("proximity observer error: \(error)")
        })
        
        defineProximityZones()
        if let proximityObserver = proximityObserver {
            proximityObserver.startObserving(proximityZones)
            print("Start observing the pill box!")
        }
        
        //self.triggerManager.delegate = self
        
        // - Calendar:
        //eventstore = EKEventStore()
        
        // Remove all notificationrequests
        
        let takenAction = UNNotificationAction(identifier: "Taken",
                                                title: "Marker som taget", options: [])
        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                title: "Fjern", options: [.destructive])
        
        let medicineCategory = UNNotificationCategory(identifier: "MedicineReminder",
                                              actions: [takenAction,deleteAction],
                                              intentIdentifiers: [], options: [])
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "OK", options: [])
        
        let boxCategory = UNNotificationCategory(identifier: "PillBox", actions: [snoozeAction,deleteAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([medicineCategory, boxCategory])
        
        notificationMaker.createNotification(title: "Tag medicin", subtitle: "Panodil", body: "Det er tid til at tage 2 af Panodil", categoryIdentifier: "MedicineReminder", identifier: "MyFavoriteNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 60, repeats: false))
        
        
        // check if we have access to calendars, and create a calendar for the app.
        /*eventstore.requestAccess(to: .reminder) { (granted, error) in
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
        }*/
        
        /*
        _ = ESTOrientationRule.orientationEquals(.horizontalUpsideDown, for: .car)
        //let rule3 = ESTProximityRule.inRangeOfNearableIdentifier("3a5bec086df14f2e")
        let rule2 = ESTProximityRule.outsideRange(ofNearableIdentifier: "7946c1b3ad6b2184")
        let trigger2 = ESTTrigger(rules: [rule2], identifier: "leave the beacon")
        
        self.triggerManager.startMonitoring(for: trigger2)*/
        
        print("Done with app setup!")
        
        return true
    }
    
    func triggerManager(_ manager: ESTTriggerManager,
                        triggerChangedState trigger: ESTTrigger) {
        if (trigger.identifier == "leave the beacon" && trigger.state == true) {
            print("Hello, digital world! The physical world has spoken.")
            notificationMaker.createNotification(title: "Pilleæske-advarsel!", subtitle: "", body: "Du er på vej væk fra din medicinæske.", categoryIdentifier: "PillBox", identifier: "distanceNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false))
        } else {
            print("Goodnight. <spoken in the voice of a turret from Portal>")
            notificationMaker.createNotification(title: "Pilleæske", subtitle: "", body: "Nu er du i nærheden af æsken igen.", categoryIdentifier: "PillBox", identifier: "distanceNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false))
        }
    }
    
    func defineProximityZones(){
        let pillBox = "pillBox"
        let zonePillBox = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 1)!, attachmentKey: "pill", attachmentValue: pillBox)
        
        zonePillBox.onEnterAction = { attachment in
            self.notificationMaker.createNotification(title: "Pilleæske", subtitle: "", body: "Du er meget tæt på æsken. Skal du tage noget medicin?", categoryIdentifier: "PillBox", identifier: "distanceNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false))
        }
        
        zonePillBox.onExitAction = { attachment in
            print("Exiting near zone")
        }
        
        zonePillBox.onChangeAction = { attachments in
            let rooms = attachments.compactMap {
                $0.payload["pill"]
            }
            print("Nearby \(pillBox) rooms: \(rooms)")
        }
        
        let zonePillBoxFar = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 10)!, attachmentKey: "pill", attachmentValue: pillBox)
        
        zonePillBoxFar.onExitAction = { attachments in
            self.notificationMaker.createNotification(title: "Pilleæske-advarsel!", subtitle: "Har du glemt din æske?", body: "Du er på vej (langt) væk fra din medicinæske.", categoryIdentifier: "PillBox", identifier: "distanceNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false))
        }
        
        zonePillBoxFar.onEnterAction = { attachments in
            self.notificationMaker.createNotification(title: "Pilleæske", subtitle: "", body: "Du er i nærheden af æsken.", categoryIdentifier: "PillBox", identifier: "distanceNotification", trigger: UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false))
        }
        
        proximityZones.append(zonePillBox)
        proximityZones.append(zonePillBoxFar)
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

