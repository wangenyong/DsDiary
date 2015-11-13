//
//  ViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiarySavedControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "DiaryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DiaryTableViewCell")
        tableView.separatorStyle = .None
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
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryTableViewCell", forIndexPath: indexPath) as! DiaryTableViewCell
        
        if indexPath.row % 2 == 1 {
            cell.contentView.backgroundColor = UIColor.thirdColor()
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
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

