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
    
    let searchController = UISearchController(searchResultsController: nil)
    let realm            = try! Realm()
    var diarys           = try! Realm().objects(Diary).sorted("date", ascending: false)
    var notificationToken: NotificationToken?
    let dateFormatter    = NSDateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: "DiaryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DiaryTableViewCell")
        tableView.separatorStyle = .None

        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        dateFormatter.locale = NSLocale.currentLocale()
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
        } else if segue.identifier == "showSettings" {
            //let vc = segue.destinationViewController
        }
    }
    
    func filterContentForSearchText(startDate: NSDate, endDate: NSDate) {
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        diarys = try! Realm().objects(Diary).filter(predicate).sorted("date", ascending: false)
        tableView.reloadData()
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

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        //搜索识别为年月日
        if searchText.isDate() {
            let calendar             = NSCalendar.currentCalendar()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate            = dateFormatter.dateFromString(searchText)
            let oneDate              = NSDateComponents()
            oneDate.day              = 1
            let endDate              = calendar.dateByAddingComponents(oneDate, toDate: startDate!, options:NSCalendarOptions(rawValue: 0))
            filterContentForSearchText(startDate!, endDate: endDate!)
        //搜索识别为年月
        } else if searchText.isMonth() {
            dateFormatter.dateFormat      = "yyyy-MM"
            let date                      = dateFormatter.dateFromString(searchText)
            let calendar                  = NSCalendar.currentCalendar()
            let unitFlags: NSCalendarUnit = [.Era, .Year, .Month, .Day, .Hour]
            let components                = calendar.components(unitFlags, fromDate: date!)
            components.day                = 1
            let beginningOfCurrentMonth   = calendar.dateFromComponents(components)
            let oneMonth                  = NSDateComponents()
            oneMonth.month                = 1
            let beginningOfNextMonth      = calendar.dateByAddingComponents(oneMonth, toDate: beginningOfCurrentMonth!, options: NSCalendarOptions(rawValue: 0))
            filterContentForSearchText(beginningOfCurrentMonth!, endDate: beginningOfNextMonth!)
        //搜索识别为年
        } else if searchText.isYear() {
            dateFormatter.dateFormat      = "yyyy"
            let date                      = dateFormatter.dateFromString(searchText)
            let calendar                  = NSCalendar.currentCalendar()
            let unitFlags: NSCalendarUnit = [.Era, .Year, .Month, .Day, .Hour]
            let components                = calendar.components(unitFlags, fromDate: date!)
            components.month              = 1
            components.day                = 1
            let beginningOfCurrentYear    = calendar.dateFromComponents(components)
            let oneYear                   = NSDateComponents()
            oneYear.year                  = 1
            let beginningOfNextYear       = calendar.dateByAddingComponents(oneYear, toDate: beginningOfCurrentYear!, options: NSCalendarOptions(rawValue: 0))
            filterContentForSearchText(beginningOfCurrentYear!, endDate: beginningOfNextYear!)
        }
    }
}


