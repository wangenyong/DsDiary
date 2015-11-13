//
//  CalendarViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var delegate: CalendarSelectedControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
}


extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
}


extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdaySelectedTextSize() -> CGFloat {
        return 12
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return UIColor.grayColor()
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return UIColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 54/255.0, green: 171/255.0, blue: 169/255.0, alpha: 1.0)
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    func didSelectDayView(dayView: DayView) {
        if delegate != nil {
            delegate?.saveCalendar(dayView.date)
        }
    }
}


public protocol CalendarSelectedControllerDelegate {
    func saveCalendar(date: CVDate)
}