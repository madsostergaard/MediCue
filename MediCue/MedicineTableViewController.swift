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
        thisRef.setValue(medicine.toAnyObject())
        
        addReminders(medicine: medicine)
    }
    
    func delete(medicine: Medicine){
        let thisRef = self.ref.child(medicine.ref)
        thisRef.removeValue()
    }
    
    func addReminders(medicine: Medicine){
        let eventStore = EKEventStore()
        
        if let calendar = eventStore.calendar(withIdentifier: UserDefaults.standard.string(forKey: "MediCuePrimaryCalendar")!) {
            
            print("we're in!")
            
            let newReminder = EKReminder(eventStore: eventStore)
            newReminder.calendar = calendar
            newReminder.title = medicine.name
            
            let someDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
            let comps = Calendar.current.dateComponents([.year, .month, .day, .minute, .hour], from: someDate!)
            newReminder.startDateComponents = comps
            
            let alarm = EKAlarm.init(absoluteDate: Calendar.current.date(byAdding: .minute, value: 1, to: Date())!)
            //alarm.relativeOffset = 0
            
            newReminder.addAlarm(alarm)
            
            let recurrence = EKRecurrenceRule.init(recurrenceWith: EKRecurrenceFrequency.daily, interval: 2, end: EKRecurrenceEnd.init(end: Date.distantFuture))
            
            newReminder.addRecurrenceRule(recurrence)
            newReminder.dueDateComponents = comps
            
            
            do { try eventStore.save(newReminder, commit: true)
                
            } catch {
                let alert = UIAlertController(title: "Event could not save", message: (error as Error).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                print(error)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func removeReminders(medicine: Medicine){
        
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
