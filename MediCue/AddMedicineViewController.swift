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
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTidspunkt" {
            
            // create a MedicineTimes object and set interval
            var medTimesTemp = MedicineTimes.init()
            
            //print(interval.titleForSegment(at: interval.selectedSegmentIndex)!)
            
            medTimesTemp.frequency = MedicineTimes.interval(rawValue: interval.titleForSegment(at: interval.selectedSegmentIndex)!)
            
            
            
            let testMed = Medicine(name: "TestMed")
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
                               endDate: testMed?.stringToDate(from: endDateTextField.text!),
                               medType: medType,
                               medTimes: medTimesTemp)
            
            let nav = segue.destination as! UINavigationController
            if nav.topViewController != nil {
                print("TOPVIEW NOT NIL")
            }
            else {
                print("TOPVIEW NIL")
            }
            if let addMedicineTimes = nav.topViewController as? AddMedicineTimesViewController {
                addMedicineTimes.med = med
            }
            else {
                print("NOT ADDMEDICINEVC")
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
