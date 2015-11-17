//
//  Diary+CoreDataProperties.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/16.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Diary {

    @NSManaged var content: String?
    @NSManaged var date: NSDate?
    @NSManaged var weather: String?

}
