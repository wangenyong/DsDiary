//
//  StringAdditions.swift
//  DsDiary
//
//  Created by wangenyong on 16/1/22.
//  Copyright © 2016年 ___WANGDASHUI___. All rights reserved.
//

import Foundation

extension String {
    func isYear() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]{4}$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
    
    func isMonth() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]{4}-[01][0-9]$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
    
    func isDate() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]{4}-[01][0-9]-[0-3][0-9]$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
}