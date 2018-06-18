//
//  CalendarViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit
import Firebase
import JTAppleCalendar

enum SelectedStyle {
    case Dark
    case Light
}

class CalendarViewController: UIViewController{
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBAction func goToTodayAction(_ sender: UIBarButtonItem) {
        self.calendarView.selectDates([self.currentDate]);
        self.calendarView.reloadData();
        self.calendarView.scrollToDate(self.currentDate, triggerScrollToDateDelegate: true, animateScroll: true);
    }
    
    let formatter = DateFormatter()
    var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        
        title = makeTitleText()
    }
    
    func makeTitleText(visibleDates: DateSegmentInfo) -> String{
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "MMMM"
        var text = formatter.string(from: date)
        text = text.capitalized
        
        formatter.dateFormat = "yyyy"
        text = text + " \(formatter.string(from: date))"
        
        return text
    }
    
    func makeTitleText() -> String {
        let date = Date()
        formatter.dateFormat = "MMMM"
        var text = formatter.string(from: date)
        text = text.capitalized
        
        formatter.dateFormat = "yyyy"
        text = text + " \(formatter.string(from: date))"
        return text
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //let first = (self.currentDate.adding(months: -2)?.startOfMonth())!;
        //let last = (self.currentDate.adding(months: 2)?.endOfMonth())!;
        //let appointments = CalendarApple.getAppointments(startDate: first, endDate: last);
        
        self.calendarView.selectDates([self.currentDate]);
        self.calendarView.reloadData();
        self.calendarView.scrollToDate(self.currentDate, triggerScrollToDateDelegate: false, animateScroll: false);
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected{
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected{
            validCell.dateLabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = .black
            } else {
                validCell.dateLabel.textColor = .gray
            }
        }
    }
}

extension CalendarViewController:  JTAppleCalendarViewDataSource{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let dateStart = Calendar.current.date(byAdding: .month, value: -3, to: self.currentDate)!
        let dateEnd = Calendar.current.date(byAdding: .month, value: 3, to: self.currentDate)!
        
        let parameters = ConfigurationParameters(startDate: dateStart, endDate: dateEnd, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday);
        
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        title = makeTitleText(visibleDates: visibleDates)
    }
}

extension UIView{
    func bounce(){
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1) })
    }
}
