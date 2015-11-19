//
//  SettingsTableViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/19.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var pdfExportCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == pdfExportCell {
            savePDFFile()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func savePDFFile() {
        let pdfFileName = "dsdiary.pdf"
        let pdfPath = getDocumentsDirectory().stringByAppendingPathComponent(pdfFileName)
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil)
        
        var currentRange = CFRangeMake(0, 0)
        var currentPage = 0
        var done = false
        
        repeat {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
            currentPage++
            drawPageNumber(currentPage)
        } while done
        
        UIGraphicsEndPDFContext()
    }
    
    func drawPageNumber(pageNum: Int) {
        let pageString = "Page \(pageNum)" as NSString
        let font = UIFont.systemFontOfSize(12)
        let maxSize = CGSizeMake(612, 72)
        
        let pageStringRect = pageString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        let pageStringSize = pageStringRect.size
        
        let stringRect = CGRectMake(((612.0-pageStringSize.width)/2.0), 720.0+((72.0-pageStringSize.height)/2.0), pageStringSize.width, pageStringSize.height)
        
        pageString.drawInRect(stringRect, withAttributes: [NSFontAttributeName : font])
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
