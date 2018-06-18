//
//  HomeViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var pillBoxIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let months = ["Januar", "Februar","Marts","April","Maj","Juni","Juli","August","September","Oktober","November", "December"]
    
    let weekdays = ["Mandag","Tirsdag","Onsdag","Torsdag","Fredag","Lørdag","Søndag"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // update text fields:
        let date = Date(timeIntervalSinceNow: 0)
        var calendar = Calendar.current
        //calendar.timeZone = TimeZone(identifier: "Berlin")!
        var dayOfWeek = calendar.component(.weekday, from: date) + 1 - calendar.firstWeekday
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        dateLabel.text = "\(day). \(months[month-1])"
        dayLabel.text = "\(weekdays[dayOfWeek-1])"
        //dayLabel.textColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
