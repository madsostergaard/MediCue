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
            var somePicker = UIPickerView()
            pickers.append(somePicker)
            inputs[i].inputView = somePicker
        }
        
        /*
         pickers.append(inputMorgen.inputView as! UIPickerView)
         pickers.append(inputFormiddag.inputView as! UIPickerView)
         pickers.append(inputMiddag.inputView as! UIPickerView)
         pickers.append(inputEftermiddag.inputView as! UIPickerView)
         pickers.append(inputAften.inputView as! UIPickerView)
         pickers.append(inputNat.inputView as! UIPickerView)*/
        
        for ui in pickers{
            ui.delegate = self
        }
        
        //inputMorgen.inputView = uiPicker
        //inputFormiddag.inputView = uiPicker
        //inputMiddag.inputView = uiPicker
        //inputEftermiddag.inputView = uiPicker
        //inputAften.inputView = uiPicker
        //inputNat.inputView = uiPicker
        //uiPicker.delegate = self
        
        var i: Int = 0;
        for check in checks{
            print("userinteraction is checked")
            if (check?.on)!{
                print("is enabled ", check?.isEnabled)
                print(" is on", check?.on)
                
                inputs[i].isUserInteractionEnabled = true
                print("allow is true for ", inputs[i].description)
            } else {
                inputs[i].isUserInteractionEnabled = false
                print("allow is false for ", inputs[i].description)
            }
            i = i+1
        }
        print("slut print \n")
        print(checkMorgen.on)
        print(checkMorgen.isEnabled)
        
        
    }
    
    func configureView(){
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
