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
            return NSLocalizedString("Sunday", comment: "Sunday")
        case 2:
            return NSLocalizedString("Monday", comment: "Monday")
        case 3:
            return NSLocalizedString("Tuesday", comment: "Tuesday")
        case 4:
            return NSLocalizedString("Wednesday", comment: "Wednesday")
        case 5:
            return NSLocalizedString("Thurday", comment: "Thurday")
        case 6:
            return NSLocalizedString("Friday", comment: "Friday")
        case 7:
            return NSLocalizedString("Saturday", comment: "Saturday")
        default:
            return NSLocalizedString("not weekday", comment: "not weekday")
        }
        
    }
}
