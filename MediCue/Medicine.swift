//
//  Medicine.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import Foundation
import Firebase

struct MedicineTimes {
    var morning: Int? = 0
    var lateMorning: Int? = 0
    var midday: Int? = 0
    var afternoon: Int? = 0
    var evening: Int? = 0
    var frequency: interval?
    
    enum interval: String {
        case daily = "Dagligt"
        case secondDay = "Hver 2. dag"
        case weekly = "Ugentligt"
    }
}

class Medicine: NSObject{
    var ref: String = ""
    var name: String
    var size: Int?{
        didSet{
            if let num = size{
                pillState = num
            }
        }}
    var pillState: Int?{
        didSet{
            if let num = size, let val = pillState {
                if Double(val) <= (0.2 * Double(num)){
                    buyNewMeds = true
                } else{
                    buyNewMeds = false
                }
            }
        }
    }
    var date: Date?
    var endDate: Date? = Date.distantFuture
    var times: MedicineTimes?
    var medType: MedicineType?
    var buyNewMeds: Bool = false
    
    enum MedicineType: String{
        case injektion, tablet, pill
    }
    
    init?(name: String, size: Int? = 0, date: Date? = Date.distantPast, endDate: Date? = Date.distantFuture, medType: MedicineType? = nil, medTimes: MedicineTimes? = nil){
        self.name = name
        
        guard !name.isEmpty else {
            return nil
        }
        
        self.size = size
        self.date = date
        self.endDate = endDate
        self.times = medTimes
        self.medType = medType
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValues = snapshot.value as! [String : AnyObject]
        name = snapshotValues["name"] as! String
        size = snapshotValues["size"] as? Int
        super.init()
        
        // get Date strings
        let startDateString = snapshotValues["startDate"] as! String
        let endDateString = snapshotValues["endDate"] as! String
        
        // save to date objects
        date = stringToDate(from: startDateString)
        endDate = stringToDate(from: endDateString)
        
        let typeString = snapshotValues["medType"] as! String
        if typeString == MedicineType.injektion.rawValue{
            medType = MedicineType.injektion
        } else if typeString == MedicineType.pill.rawValue{
            medType = MedicineType.pill
        } else{
            medType = MedicineType.tablet
        }
        
        ref = snapshotValues["ref"] as! String
        
        // get the medicine times:
        let medtimesValues = snapshot.childSnapshot(forPath: "medTimes").value as! [String: AnyObject]
        //        print(medtimesValues)
        var newTimes = MedicineTimes.init()
        newTimes.afternoon = medtimesValues["afternoon"] as? Int
        newTimes.evening = medtimesValues["evening"] as? Int
        let freqString = medtimesValues["frequency"] as? String
        //        print(freqString!)
        if freqString == MedicineTimes.interval.daily.rawValue{
            newTimes.frequency = MedicineTimes.interval.daily
        } else if freqString == MedicineTimes.interval.secondDay.rawValue{
            newTimes.frequency = MedicineTimes.interval.secondDay
        } else {
            newTimes.frequency = MedicineTimes.interval.weekly
        }
        newTimes.lateMorning = medtimesValues["lateMorning"] as? Int
        newTimes.midday = medtimesValues["midday"] as? Int
        newTimes.morning = medtimesValues["morning"] as? Int
        
        // save the times in the object
        times = newTimes
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "size": size!,
            "startDate" : dateToString(from: date!),
            "endDate" : dateToString(from: endDate!),
            "medType" : medType?.rawValue ?? "pill",
            "ref" : ref,
            "medTimes" : [
                "morning" : times!.morning!,
                "lateMorning" : times!.lateMorning!,
                "midday" : times!.midday!,
                "afternoon" : times!.afternoon!,
                "evening": times!.evening!,
                "frequency" : times!.frequency?.rawValue ?? "daily"
            ]
        ]
    }
    
    func dateToString(from inputDate: Date) -> String {
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        return formatter.string(from: inputDate)
    }
    
    func stringToDate(from inputString: String) -> Date? {
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        return formatter.date(from: inputString)
    }
}
