//
//  SetTimesTableViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class SetTimesTableViewController: UITableViewController {
    
    @IBAction func switchChangedAction(_ sender: UISwitch) {
        if sender.isOn{
            changeEditing(state: true)
        } else {
            changeEditing(state: false)
        }
    }
    
    @IBOutlet weak var doEditSwitch: UISwitch!
    @IBOutlet weak var morningDP: UIDatePicker!
    @IBOutlet weak var formiddagDP: UIDatePicker!
    @IBOutlet weak var middagDP: UIDatePicker!
    @IBOutlet weak var eftermiddagDP: UIDatePicker!
    @IBOutlet weak var aftenDP: UIDatePicker!
    @IBOutlet weak var natDP: UIDatePicker!
    
    var datePickerArr = [UIDatePicker]()
    let commands = ["MorningTime","FormiddagTime","MiddagTime",
                    "EftermiddagTime","AftenTime","NatTime"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerArr = [morningDP, formiddagDP, middagDP,
                         eftermiddagDP, aftenDP, natDP]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        // setup the detail-labels with the saved times
        var i = 0
        for picker in datePickerArr{
            let text = UserDefaults.standard.string(forKey: commands[i])
            let date = dateFormatter.date(from: text!)
            
            if let newDate = date{
                picker.date = newDate
            }
            
            i += 1
        }
        
        title = "Indstil tidspunkter"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var i = 0
        for picker in datePickerArr{
            let date = picker.date
            let dateText = formatter.string(from: date)
            //print(dateText)
            
            UserDefaults.standard.set(dateText, forKey: commands[i])
            i += 1
        }
    }
    
    func changeEditing(state: Bool){
        for dp in datePickerArr{
            dp.isUserInteractionEnabled = state
        }
    }
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }*/
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
