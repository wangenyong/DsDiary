//
//  CalendarViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    var delegate: CalendarSelectedControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.textColor = UIColor.secondaryColor()
        dateLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        dateLabel.text = NSDateFormatter.localizedStringFromDate(sender.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        if delegate != nil {
            delegate?.saveCalendar(sender.date)
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}





public protocol CalendarSelectedControllerDelegate {
    func saveCalendar(date: NSDate)
}