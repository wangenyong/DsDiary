//
//  ViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, DiarySavedControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var diarys = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "DiaryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DiaryTableViewCell")
        tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Diary")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            diarys = results as! [NSManagedObject]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
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
            vc.isNewDiary = false
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
        
        let date = diary.valueForKey("date") as? NSDate
        let calendar   = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let DayInt     = (calendar?.component(NSCalendarUnit.Day, fromDate: date!))!
        let MonthInt   = (calendar?.component(NSCalendarUnit.Month, fromDate: date!))!
        let YearInt    = (calendar?.component(NSCalendarUnit.Year, fromDate: date!))!
        let weekdayInt = (calendar?.component(NSCalendarUnit.Weekday, fromDate: date!))!
        
        cell.dayLabel.text       = "\(DayInt)"
        cell.monthYearLabel.text = "\(MonthInt)/\(YearInt)"
        cell.weekdayLabel.text      = weekdayInt.weekDay()
        cell.contentLabel.text = diary.valueForKey("content") as? String
        cell.weatherLabel.text = diary.valueForKey("weather") as? String
        

        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDiary", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

