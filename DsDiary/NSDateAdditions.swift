//
//  NSDateAdditions.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/17.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import Foundation

extension NSDate {
    func customFormatDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.stringFromDate(self)
    }
}