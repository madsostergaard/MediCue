//
//  MedicineTableViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit
import Firebase
import EventKit
import UserNotifications

class MedicineTableViewController: UITableViewController {
    
    var medArr = [Medicine]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("medicine")
        ref.observe(.value, with: { snapshot -> Void in
            var tempMeds: [Medicine] = []
            
            for item in snapshot.children{
                let newMed = Medicine(snapshot: item as! DataSnapshot)
                
                tempMeds.append(newMed)
            }
            
            self.medArr = tempMeds
            self.tableView.reloadData()
        })
        
        // add panodil test object to database
        fillPills()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func save(medicine: Medicine){
        let thisRef = self.ref.childByAutoId()
        medicine.ref = thisRef.key
        let newMedicine = addReminders(medicine: medicine)
        thisRef.setValue(newMedicine.toAnyObject())
    }
    
    func delete(medicine: Medicine){
        let thisRef = self.ref.child(medicine.ref)
        thisRef.removeValue()
    }
    
    func addReminders(medicine: Medicine) -> Medicine{
        let notificationMaker = NotificationMaker()
        let commands = ["MorningTime","FormiddagTime","MiddagTime",
                        "EftermiddagTime","AftenTime","NatTime"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let title = medicine.name
        let weekdays = medicine.weekdays
        var pills = [Int]()
        if let times = medicine.times {
            pills = [times.morning!, times.lateMorning!, times.midday!, times.afternoon!, times.evening!, times.night!]
        }
        
        
        let morningTime = UserDefaults.standard.string(forKey: commands[0])
        let lateMorningTime = UserDefaults.standard.string(forKey: commands[1])
        let middayTime = UserDefaults.standard.string(forKey: commands[2])
        let afternoonTime = UserDefaults.standard.string(forKey: commands[3])
        let eveningTime = UserDefaults.standard.string(forKey: commands[4])
        let nightTime = UserDefaults.standard.string(forKey: commands[5])
        let userTimes = [morningTime!, lateMorningTime!, middayTime!, afternoonTime!, eveningTime!, nightTime!]
        
        if weekdays["Man"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.monday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a monday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Tirs"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.tuesday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a tuesday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Ons"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.wednesday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a wednesday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Tors"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.thursday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                     print("added a thursday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Fre"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.friday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a friday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Lør"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.saturday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a saturday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        if weekdays["Søn"]!{
            for i in 0...pills.count-1 {
                if pills[i] > 0 {
                    let body = "Det er tid til at tage \(pills[i]) af \(medicine.name)"
                    let identifier = UUID.init().uuidString
                    medicine.identifiers.append(identifier)
                    
                    var dateTemp = Date()
                    var date = Date()
                    print(date)
                    
                    let timesTemp = userTimes[i].split(separator: ":")
                    if let hour = Int(timesTemp[0]), let minute = Int(timesTemp[1]){
                        dateTemp = Date.today().next(.sunday)
                        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateTemp)!
                    }
                    
                    
                    print(date)
                    print(Calendar.current.dateComponents([.weekday,.hour,.minute], from: date))
                    
                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerWeekly, repeats: true)
                    
                    print("added a sunday time at \(userTimes[i])")
                    
                    notificationMaker.createNotification(title: title, subtitle: "", body: body, categoryIdentifier: "MedicineReminder", identifier: identifier, trigger: trigger)
                }
            }
        }
        
        return medicine
    }
    
    func removeReminders(medicine: Medicine){
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: medicine.identifiers)
    }
    
    // function to create a test medicine
    func fillPills(){
        var medtimes = MedicineTimes.init()
        medtimes.morning = 1
        medtimes.evening = 2
        //medtimes.frequency = MedicineTimes.interval.daily
        
        let med = Medicine(name: "Panodil", size: 20, date: Date(timeIntervalSinceNow: 0), medType: Medicine.MedicineType.pill, medTimes: medtimes)
        
        //save(medicine: med!)
        sortPills()
    }
    
    // sort medicine alphabetically
    func sortPills(){
        medArr.sort { (medArr1, medArr2) -> Bool in
            //if medArr1.name != medArr2.name{
            return medArr1.name < medArr2.name
            //}
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MedicineCell = tableView.dequeueReusableCell(withIdentifier: "medsCell", for: indexPath) as! MedicineCell
        
        let thisMedicine = medArr[indexPath.row]
        
        cell.medicineNameLabel?.text = thisMedicine.name
        cell.medicineFreqLabel?.text = thisMedicine.frequency?.rawValue
        
        if let thisType = thisMedicine.medType{
            switch thisType {
            case Medicine.MedicineType.injektion:
                cell.medicineIcon.image = UIImage(named: "injectionIcon.pdf")
            case Medicine.MedicineType.pill:
                cell.medicineIcon.image = UIImage(named: "pillIcon.pdf")
            case Medicine.MedicineType.tablet:
                cell.medicineIcon.image = UIImage(named: "capsuleIcon.pdf")
            }}
        
        return cell
    }
    
    @IBAction func unwindToMedicineTableView(segue: UIStoryboardSegue){
        if segue.identifier == "addMedicineSegue" {
            let sourceController = segue.source as! AddMedicineViewController
            if let newMedicine = sourceController.med{
                save(medicine: newMedicine)
            }
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let medicineItem = medArr[indexPath.row]
            let thisRef = self.ref.child(medicineItem.ref)
            thisRef.removeValue()
            removeReminders(medicine: medicineItem)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetails"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Prepare to send object to details")
                let detailedMed = medArr[indexPath.row]
                
                let medicineDetailsViewController = segue.destination as! MedicineDetailsViewController
                medicineDetailsViewController.thisMedicine = detailedMed
            }
        }
    }
    
    
}

class MedicineCell: UITableViewCell{
    @IBOutlet weak var medicineIcon: UIImageView!
    @IBOutlet weak var medicineFreqLabel: UILabel!
    @IBOutlet weak var medicineNameLabel: UILabel!
}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}



