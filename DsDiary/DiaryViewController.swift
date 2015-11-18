//
//  DiaryViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import RealmSwift
import Dodo

class DiaryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let PLACEHOLDER_TEXT = NSLocalizedString("DiaryPlaceholder", comment: "Placehoulder")
    
    var diary: Diary?
    
    var weather: Weathers = Weathers.Sun {
        didSet {
            weatherLabel.text = NSLocalizedString(weather.rawValue, comment: "Weather") 
        }
    }
    
    var date: NSDate = NSDate() {
        didSet {
            dateLabel.text = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
    }
    
    var delegate: DiarySavedControllerDelegate?

    override func viewDidLoad() {
        if diary != nil {
            textView.editable = false
            date          = diary!.date
            weather       = Weathers(rawValue: diary!.weather)!
            textView.text = diary?.content
        } else {
            textView.becomeFirstResponder()
            applyPlaceholderStyle(textView!, placeholderText: PLACEHOLDER_TEXT)
            dateLabel.text    = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            weatherLabel.text = NSLocalizedString(Weathers.Sun.rawValue, comment: "Sun")
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
        textView.delegate = self
        
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
        guard textView.text != PLACEHOLDER_TEXT  else {
            textView.textColor = UIColor.orangeColor()
            return
        }
        
        let realm = try! Realm()
        if diary != nil { //对已经保存的日记进行更新
            try! realm.write {
                self.diary!.content = self.textView.text
                self.diary!.weather = self.weather.rawValue
                self.diary!.date    = self.date
            }
        } else { //创建新的日记
            diary          = Diary()
            diary!.uuid    = NSUUID().UUIDString
            diary!.content = textView.text
            diary!.weather = weather.rawValue
            diary!.date    = date
            try! realm.write {
                realm.add(self.diary!)
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGrayColor()
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkTextColor()
        aTextview.alpha = 1.0
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        dispatch_async(dispatch_get_main_queue(), {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
    }


}

extension DiaryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        textView.backgroundColor = UIColor.thirdColor()
    }
    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool {
        if aTextView == textView && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            moveCursorToStart(aTextView)
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 { // have text, so don't show the placeholder
            // check if the only text is the placeholder and remove it if needed
            if textView == self.textView && textView.text == PLACEHOLDER_TEXT {
                if text.utf16.count == 0 { // they hit the back button
                    return false // ignore it
                }
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
            return true
        } else { // no text, so show the placeholder
            applyPlaceholderStyle(textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(textView)
            return false
        }
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
    func saveCalendar(date: NSDate) {
        self.date = date
    }
}


/**
 *  定义日记保存协议
 */
protocol DiarySavedControllerDelegate {
    func diarySaveSucceed(var diary: String)
}