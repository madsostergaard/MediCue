//
//  AddMedicineTimesViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit
import BEMCheckBox

class AddMedicineTimesViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var med: Medicine?{
        didSet{
            configureView()
        }
    }
    
    var sourceController: AddMedicineViewController?
    
    @IBOutlet var weekdays: [UIButton]!
    @IBAction func weekdayAction(_ sender: UIButton) {
        if sender.tintColor == UIColor.red {
            sender.tintColor = UIColor.green
        } else {
            sender.tintColor = UIColor.red
        }
    }
    
    // ---- text outlets
    @IBOutlet weak var inputMorgen: UITextField!
    @IBOutlet weak var inputFormiddag: UITextField!
    @IBOutlet weak var inputMiddag: UITextField!
    @IBOutlet weak var inputEftermiddag: UITextField!
    @IBOutlet weak var inputAften: UITextField!
    @IBOutlet weak var inputNat: UITextField!
    var inputs = [UITextField]()
    
    // ---- checkmark outlets
    @IBOutlet weak var checkMorgen: BEMCheckBox!
    @IBOutlet weak var checkFormiddag: BEMCheckBox!
    @IBOutlet weak var checkMiddag: BEMCheckBox!
    @IBOutlet weak var checkEftermiddag: BEMCheckBox!
    @IBOutlet weak var checkAften: BEMCheckBox!
    @IBOutlet weak var checkNat: BEMCheckBox!
    var checks = [BEMCheckBox!]()
    
    let uiPicker = UIPickerView()
    var pickers = [UIPickerView]()
    let arr = Array(1...20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputs = [inputMorgen, inputFormiddag, inputMiddag, inputEftermiddag, inputAften, inputNat]
        checks = [checkMorgen, checkFormiddag, checkMiddag, checkEftermiddag, checkAften, checkNat]
        
        for checkBox in checks {
            checkBox?.delegate = self
        }
        
        for i in 0...checks.count-1{
            let somePicker = UIPickerView()
            pickers.append(somePicker)
            inputs[i].inputView = somePicker
        }
        
        for btn in weekdays{
            print("Changing button: \(btn.titleLabel!)")
            btn.tintColor = UIColor.red
        }
        
        for ui in pickers{
            ui.delegate = self
        }
        
        var i: Int = 0;
        for check in checks{
            print("userinteraction is checked")
            if (check?.on)!{
                inputs[i].isUserInteractionEnabled = true
                print("allow is true for ", inputs[i].description)
            } else {
                inputs[i].isUserInteractionEnabled = false
                print("allow is false for ", inputs[i].description)
            }
            i = i+1
        }
        print("slut print \n")
        
    }
    
    func configureView(){
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arr[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputs[pickers.index(of: pickerView)!].text = String(arr[row])
        
        // inputs[row].text = String(arr[row])
        
        print("picker row: ", pickers.index(of: pickerView)!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func activateInputField(box: BEMCheckBox){
        
        var j: Int = 0
        for checkBox in checks{
            if checkBox==box{
                inputs[j].isUserInteractionEnabled = true
            } else {
                j = j + 1
            }
        }
    }
    
    func disableInputField(box: BEMCheckBox){
        var j: Int = 0
        for checkBox in checks{
            
            if checkBox==box{
                inputs[j].isUserInteractionEnabled = false
                inputs[j].text = "0"
            } else {
                j = j + 1
            }
        }
    }
    
    // send the edited
    override func viewWillDisappear(_ animated: Bool) {
        // check weekdays
        for btn in weekdays {
            if let txt = btn.titleLabel?.text{
                switch txt {
                case "Man":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Man"] = true
                    }
                    break
                case "Tirs":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Tirs"] = true
                    }
                    break
                case "Ons":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Ons"] = true
                    }
                    break
                case "Tors":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Tors"] = true
                    }
                    break
                case "Fre":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Fre"] = true
                    }
                    break
                case "Lør":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Lør"] = true
                    }
                    break
                case "Søn":
                    if isBtnActivated(button: btn){
                        med?.weekdays["Søn"] = true
                    }
                    break
                default:
                    break
                }
            }
        }
        
        // get times
        var times = MedicineTimes()
        times.morning = Int(inputMorgen.text!)
        times.lateMorning = Int(inputFormiddag.text!)
        times.midday = Int(inputMiddag.text!)
        times.afternoon = Int(inputEftermiddag.text!)
        times.evening = Int(inputAften.text!)
        times.night = Int(inputNat.text!)
        
        med?.times = times
        
        // send information to source controller (if not nil)
        sourceController?.med = self.med
    }
    
    func isBtnActivated(button: UIButton) -> Bool {
        if button.tintColor == .red{
            return false
        } else {
            return true
        }
    }
}

extension AddMedicineTimesViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if (checkBox.on) {
            activateInputField(box: checkBox)
        } else{
            disableInputField(box: checkBox)
        }
    }
}
