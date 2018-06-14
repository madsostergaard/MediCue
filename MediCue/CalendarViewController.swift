//
//  CalendarViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift
import Firebase

enum SelectedStyle {
    case Dark
    case Light
}



// From example of CalendarKit:

class CalendarViewController: DayViewController, DatePickerControllerDelegate{
    
    //    var data = [["Breakfast at Tiffany's",
    //                 "New York, 5th avenue"],
    //
    //                ["Workout",
    //                 "Tufteparken"],
    //
    //                ["Meeting with Alex",
    //                 "Home",
    //                 "Oslo, Tjuvholmen"],
    //
    //                ["Beach Volleyball",
    //                 "Ipanema Beach",
    //                 "Rio De Janeiro"],
    //
    //                ["WWDC",
    //                 "Moscone West Convention Center",
    //                 "747 Howard St"],
    //
    //                ["Google I/O",
    //                 "Shoreline Amphitheatre",
    //                 "One Amphitheatre Parkway"],
    //
    //                ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
    //                 "Oslo Gardermoen"],
    //
    //                ["💻📲 Developing CalendarKit",
    //                 "🌍 Worldwide"],
    //
    //                ["Software Development Lecture",
    //                 "Mikpoli MB310",
    //                 "Craig Federighi"],
    //
    //                ]
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    var currentStyle = SelectedStyle.Light
    
    var newData = [[String]]()
    var medArr = [Medicine](){
        didSet{
            var num: Int = 0
            for medicine in medArr{
                if let number = medicine.times?.morning{
                    num = number
                }
                for _ in 1...5 {
                    let makeSomeText = [medicine.name, "Antal piller: \(num)"]
                    newData.append(makeSomeText)
                }
            }
            reloadData()
        }
    }
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
        })
        
        
        
        
        //title = "CalendarKit Demo"
        
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
    }
    
    func datePicker(controller: DatePickerController, didSelect date: Date?) {
        if let date = date {
            dayView.state?.move(to: date)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: EventDataSource
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var date = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
        var events = [Event]()
        
        for i in 0...4 {
            let event = Event()
            //let duration = Int(arc4random_uniform(160) + 60)
            let datePeriod = TimePeriod(beginning: date,
                                        chunk: TimeChunk.dateComponents(minutes: 60))
            
            event.startDate = datePeriod.beginning!
            event.endDate = datePeriod.end!
            
            if newData.count != 0 {
                var info = newData[Int(arc4random_uniform(UInt32(newData.count)))]
                info.append("\(datePeriod.beginning!.format(with: "dd.MM.YYYY"))")
                info.append("\(datePeriod.beginning!.format(with: "HH:mm"))")
                //) -\(datePeriod.end!.format(with: "HH:mm"))")
                event.text = info.reduce("", {$0 + $1 + "\n"})
                event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
                //event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
                
                // Event styles are updated independently from CalendarStyle
                // hence the need to specify exact colors in case of Dark style
                if currentStyle == .Dark {
                    event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
                    event.backgroundColor = event.color.withAlphaComponent(0.6)
                }
                
                events.append(event)
                
                let nextOffset = Int(arc4random_uniform(250) + 40)
                date = date.add(TimeChunk.dateComponents(minutes: nextOffset))
                event.userInfo = String(i)
            }}
        
        return events
    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    // MARK: DayViewDelegate
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
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
