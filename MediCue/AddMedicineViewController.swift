//
//  AddMedicineViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class AddMedicineViewController: UIViewController {
    
    var med: Medicine?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var packageCountTextField: UITextField!
    @IBOutlet weak var activateEndDateSwitch: UISwitch!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var interval: UISegmentedControl!
    
    @IBAction func activateChanged(_ sender: Any) {
        if activateEndDateSwitch.isOn{
            print("IsON!")
            //endDateTextField.isUserInteractionEnabled = true
            endDateTextField.isEnabled = true
        } else{
            print("isOFF!")
            endDateTextField.isEnabled = false
            //endDateTextField.isUserInteractionEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beginDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        beginDatePicker.datePickerMode = UIDatePickerMode.date
        endDatePicker.datePickerMode = UIDatePickerMode.date
        
        beginDatePicker.addTarget(self, action: #selector(AddMedicineViewController.startDatePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        endDatePicker.addTarget(self, action: #selector(AddMedicineViewController.endDatePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        startDateTextField.inputView = beginDatePicker
        endDateTextField.inputView = endDatePicker
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        startDateTextField.placeholder = "Eks: \(formatter.string(from: Date()))"
        
        if let thisMed = med {
            nameTextField.text = thisMed.name
            startDateTextField.text = thisMed.dateToString(from: thisMed.date!)
            packageCountTextField.text = String(thisMed.size!)
            
            if let enddate = thisMed.endDate{
                endDateTextField.text = thisMed.dateToString(from: enddate)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSetTimes" {
            
            // create a MedicineTimes object and set interval
            let medTimesTemp = MedicineTimes.init()
            
            //print(interval.titleForSegment(at: interval.selectedSegmentIndex)!)
            
            let testMed = Medicine(name: "TestMed")
            
            testMed?.frequency = MedicineTimes.interval(rawValue: interval.titleForSegment(at: interval.selectedSegmentIndex)!)
            
            let medType: Medicine.MedicineType
            // print(medTimesTemp.frequency!)
            let typeString = typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex)!
            if typeString == Medicine.MedicineType.injektion.rawValue{
                medType = Medicine.MedicineType.injektion
            } else if typeString == Medicine.MedicineType.pill.rawValue{
                medType = Medicine.MedicineType.pill
            } else{
                medType = Medicine.MedicineType.tablet
            }
            
            let med = Medicine(name: nameTextField.text!,
                               size: Int(packageCountTextField.text!),
                               date: testMed?.stringToDate(from: startDateTextField.text!),
                               medType: medType,
                               medTimes: medTimesTemp)
            
            if activateEndDateSwitch.isOn{
                med?.endDate = med?.stringToDate(from: endDateTextField.text!)
            }
            
            // get the destination object and set the sourceController to this object
            let nav = segue.destination as? AddMedicineTimesViewController
            if let addMedicineTimes = nav {
                addMedicineTimes.med = med
                addMedicineTimes.sourceController = self
            }
            else {
                print("NOT ADDMEDICINEVC (i.e. nil)")
            }
            
        }
    }
    
    @objc func startDatePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        startDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func endDatePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        endDateTextField.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
