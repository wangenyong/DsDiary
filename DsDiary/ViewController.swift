//
//  ViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, DiarySavedControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let diarys = try! Realm().objects(Diary).sorted("date", ascending: false)
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "DiaryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DiaryTableViewCell")
        tableView.separatorStyle = .None
        
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDiary" {
            let vc = segue.destinationViewController as! DiaryViewController
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: vc, action: "diaryEdit")
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.diary = diarys[indexPath.row]
            }
            vc.delegate = self
      
        } else if segue.identifier == "newDiary" {
            let vc = segue.destinationViewController as! DiaryViewController
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: vc, action: "diarySave")
            vc.delegate = self
        }
    }
    
    /**
     日记保存成功后的回调方法
     
     - parameter diary: 保存成功的日记
     */
    func diarySaveSucceed(diary: String) {
        self.tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryTableViewCell", forIndexPath: indexPath) as! DiaryTableViewCell
        
        if indexPath.row % 2 == 1 {
            cell.contentView.backgroundColor = UIColor.thirdColor()
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        let diary = diarys[indexPath.row]
        
        let date       = diary.date
        let calendar   = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let DayInt     = (calendar?.component(NSCalendarUnit.Day, fromDate: date))!
        let MonthInt   = (calendar?.component(NSCalendarUnit.Month, fromDate: date))!
        let YearInt    = (calendar?.component(NSCalendarUnit.Year, fromDate: date))!
        let weekdayInt = (calendar?.component(NSCalendarUnit.Weekday, fromDate: date))!
        
        cell.dayLabel.text       = "\(DayInt)"
        cell.monthYearLabel.text = "\(MonthInt)/\(YearInt)"
        cell.weekdayLabel.text   = weekdayInt.weekDay()
        cell.contentLabel.text   = diary.content
        cell.weatherLabel.text   = NSLocalizedString(diary.weather, comment: "Weather")
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            try! realm.write {
                self.realm.delete(self.diarys[indexPath.row])
            }
        }
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDiary", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

