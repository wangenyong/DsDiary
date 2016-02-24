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
        let regex = try! NSRegularExpression(pattern: "^(?!0000)[0-9]{4}$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
    
    func isMonth() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?!0000)[0-9]{4}-(0?[1-9]|1[0-2])$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
    
    func isDate() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?!0000)[0-9]{4}-((0?[1-9]|1[0-2])-(0?[1-9]|1[0-9]|2[0-8])|(0?[13-9]|1[0-2])-(29|30)|(0?[13578]|1[02])-31)$",
            options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
}