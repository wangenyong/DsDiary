//
//  DiaryViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class DiaryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var isNewDiary = true
    
    var weather: Weathers = Weathers.Sun {
        didSet {
            weatherLabel.text = weather.rawValue
        }
    }
    
    var date: CVDate = CVDate(date: NSDate()) {
        didSet {
            dateLabel.text = date.commonDescription
        }
    }
    
    var delegate: DiarySavedControllerDelegate?

    override func viewDidLoad() {
        if isNewDiary {
            textView.becomeFirstResponder()
        } else {
            textView.editable = false
        }
        
        let toolbar       = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let calendarItem  = UIBarButtonItem(image: UIImage(named: "Calendar"), style: .Plain, target: self, action: "CalendarSelected:")
        let weatherItem   = UIBarButtonItem(image: UIImage(named: "Weather"), style: .Plain, target: self, action: "weatherSelected:")
        let doneItem      = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        let items         = [flexSpaceItem, calendarItem, flexSpaceItem, flexSpaceItem, weatherItem, flexSpaceItem, flexSpaceItem, doneItem, flexSpaceItem]
        for item in items {
            item.tintColor = UIColor.primaryColor()
        }
        
        toolbar.backgroundColor = UIColor.whiteColor()
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
        
        dateLabel.text    = CVDate(date: NSDate()).commonDescription
        weatherLabel.text = Weathers.Sun.rawValue
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     日记编辑方法
     */
    func diaryEdit() {
        textView.editable = true
        textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "diarySave")
    }
    
    /**
     日记保存方法
     */
    func diarySave() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Diary", inManagedObjectContext:managedContext)
        let diary = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        diary.setValue(textView.text, forKey: "content")
        diary.setValue(weather.rawValue, forKey: "weather")
        diary.setValue(date.convertedDate(), forKey: "date")
        
        do {
            try managedContext.save()
            self.navigationController?.popToRootViewControllerAnimated(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     选择日期方法
     - parameter sender: 日期 UIBarButtonItem
     */
    func CalendarSelected(sender: UIBarButtonItem!) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarViewController: CalendarViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarController") as! CalendarViewController
        calendarViewController.modalPresentationStyle = .Popover
        calendarViewController.delegate = self
        
        let popoverMenuViewController = calendarViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.barButtonItem = sender
        
        presentViewController(calendarViewController, animated: true, completion: nil)
    }
    
    /**
     选择天气方法
     - parameter sender: 天气 UIBarButtonItem
     */
    func weatherSelected(sender: UIBarButtonItem!) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherViewController: WeatherCollectionViewController = storyboard.instantiateViewControllerWithIdentifier("WeatherController") as! WeatherCollectionViewController
        weatherViewController.modalPresentationStyle = .Popover
        weatherViewController.preferredContentSize = CGSizeMake(240, 160)
        weatherViewController.delegate = self
        
        let popoverMenuViewController = weatherViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.barButtonItem = sender
        
        presentViewController(weatherViewController, animated: true, completion: nil)
    }
    
    /**
     键盘上方完成按钮
     */
    func done() {
        textView.resignFirstResponder()
    }


}

extension DiaryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

extension DiaryViewController: SavingWeatherControllerDelegate {
    /**
     保存天气协议方法
     
     - parameter weather: 选择的天气
     */
    func saveWeather(weather: Weathers) {
        self.weather = weather
    }
}

extension DiaryViewController: CalendarSelectedControllerDelegate {
    /**
     保存日期协议方法
     
     - parameter date: 选择的日期
     */
    func saveCalendar(date: CVDate) {
        self.date = date
    }
}


/**
 *  定义日记保存协议
 */
protocol DiarySavedControllerDelegate {
    func diarySaveSucceed(var diary: String)
}