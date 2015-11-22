//
//  SettingsTableViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/19.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var pdfExportCell: UITableViewCell!
    
    let diarys = try! Realm().objects(Diary).sorted("date", ascending: false)

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
            let path = savePDFFile()
            let checkValidation = NSFileManager.defaultManager()
            if (checkValidation.fileExistsAtPath(path)) {
                self.performSegueWithIdentifier("showPdfDetail", sender: path)

            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPdfDetail" {
            let vc = segue.destinationViewController as! PdfDetailViewController
            vc.path = sender as? String
        }
    }
    
    /**
     生成并保存 pdf 文件
     
     - returns: 文件的路径
     */
    func savePDFFile() -> String {
        let pdfFileName = "dsdiary.pdf"
        let pdfPath = getDocumentsDirectory().stringByAppendingPathComponent(pdfFileName)
        // Create the PDF context using the default page size of 612 x 792.
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil)
        var currentPage = 0
        var startHeight: CGFloat = 72.0
        var turnY = true
        
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        // Draw a page number at the bottom of each page.
        currentPage++
        drawPageNumber(currentPage)
        
        for diary in diarys {
            let cfstring = NSDateFormatter.localizedStringFromDate(diary.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle) + " " + NSLocalizedString(diary.weather, comment: "Weather") + "\n" + diary.content
            let currentText = CFAttributedStringCreate(nil, cfstring, nil)
            let framesetter = CTFramesetterCreateWithAttributedString(currentText)
            var currentRange = CFRangeMake(0, 0)
            
            var done = true
            repeat {
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                let result = drawText(currentRange, framesetter: framesetter, startHight: startHeight, turnY: turnY)
                
                currentRange = result.range
                startHeight += (result.heght + 8.0)
                // If we're at the end of the text, exit the loop.
                if currentRange.location != CFAttributedStringGetLength(currentText) {
                    done = false
                    // Mark the beginning of a new page.
                    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
                    // Draw a page number at the bottom of each page.
                    currentPage++
                    drawPageNumber(currentPage)
                    turnY = true
                    startHeight = 72.0
                } else if startHeight > 648.0 {
                    done = true
                    // Mark the beginning of a new page.
                    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
                    // Draw a page number at the bottom of each page.
                    currentPage++
                    drawPageNumber(currentPage)
                    turnY = true
                    startHeight = 72.0
                } else {
                    done = true
                    turnY = false
                }
            } while !done
        }
        UIGraphicsEndPDFContext()
        
        return pdfPath
    }
    
    
    /**
     在pdf页面中绘制文本内容
     
     - parameter currentRange: CFRange
     - parameter framesetter:  CTFramesetterRef
     
     - returns: CFRange
     */
    func drawText(var currentRange: CFRange, framesetter: CTFramesetterRef, startHight: CGFloat, turnY: Bool) -> (heght: CGFloat, range: CFRange) {
        //Get the graphics context.
        let currentContext = UIGraphicsGetCurrentContext()
        // Put the text matrix into a known state. This ensures
        // that no old scaling factors are left in place.
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity)
        
        if turnY {
            // Core Text draws from the bottom-left corner up, so flip
            // the current transform prior to drawing.
            CGContextTranslateCTM(currentContext, 0, 648)
            CGContextScaleCTM(currentContext, 1.0, -1.0)
        }
        
        // Create a path object to enclose the text. Use 72 point
        // margins all around the text.
        let frameRect = CGRectMake(72, -startHight, 468, 648)
        let framePath = CGPathCreateMutable()
        CGPathAddRect(framePath, nil, frameRect)
        // Get the frame that will do the rendering.
        // The currentRange variable specifies only the starting point. The framesetter
        // lays out as much text as will fit into the frame.    
        let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
        // Draw the frame.
        CTFrameDraw(frameRef, currentContext!)
        // Get the actural height that text on draw
        let lineArray = CTFrameGetLines(frameRef)
        let lineCount = CFArrayGetCount(lineArray)
        var heigh: CGFloat = 0
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        for var j = 0; j < lineCount; j++ {
            let currentLine = unsafeBitCast(CFArrayGetValueAtIndex(lineArray, j), CTLine.self)
            CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading)
            let h = ascent + descent + leading
            heigh += h
        }
        print("height: \(heigh)")
        // Update the current range based on what was drawn.
        currentRange = CTFrameGetVisibleStringRange(frameRef)
        currentRange.location += currentRange.length
        currentRange.length = 0
        
        return (heigh, currentRange)
    }
    
    
    /**
     在pdf页面底部绘制页码
     
     - parameter pageNum: 页码
     */
    func drawPageNumber(pageNum: Int) {
        let pageString = "Page \(pageNum)" as NSString
        let font = UIFont.systemFontOfSize(12)
        let maxSize = CGSizeMake(612, 72)
        
        let pageStringRect = pageString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        let pageStringSize = pageStringRect.size
        
        let stringRect = CGRectMake(((612.0-pageStringSize.width)/2.0), 720.0+((72.0-pageStringSize.height)/2.0), pageStringSize.width, pageStringSize.height)
        
        pageString.drawInRect(stringRect, withAttributes: [NSFontAttributeName : font])
    }
    
    
    /**
     获取沙盒 documents 目录
     
     - returns: documents 路径
     */
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
