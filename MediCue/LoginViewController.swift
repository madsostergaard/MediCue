//
//  LoginViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    var standardLogin: String? = "standardLogin"
    var standardPassword: String? = "standardPassword"
    let test: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func autoLogin(){
        
        if test == true {
            UserDefaults.standard.set("Maria", forKey: standardLogin!)
            UserDefaults.standard.set("Mugabe", forKey: standardPassword!)
        }
        
        let login = UserDefaults.standard.string(forKey: standardLogin!)
        let password = UserDefaults.standard.string(forKey: standardPassword!)
        if login != nil && password != nil
        {
            self.inputUsername.text = login!
            self.inputPassword.text = password!
        } else {
            self.inputUsername.text = ""
            self.inputPassword.text = ""
        }
        print("login " , login!)
        print("password " , password!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLoginView(segue: UIStoryboardSegue){
        if let id = segue.identifier {
            print("in unwindToLoginView, sender: \(id)")
            switch segue.identifier! {
            case "loggedOut":
                print("Goodbye good sir!")
            case "cancelNewUser":
                print("Awww.. Why do you hate me?")
            case "addedUser":
                print("You tried to add a new user! Hooray!")
            default:
                print("Will I be called?")
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

