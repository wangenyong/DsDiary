//
//  IntAdditions.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/15.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import Foundation

extension Int {
    func weekDay() -> String {
        switch self {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thurday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "not weekday"
        }
        
    }
}
