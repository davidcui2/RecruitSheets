//
//  CoreDataFetcher.swift
//  RecruitSheets
//
//  Created by Zhihao Cui on 19/10/2015.
//  Copyright © 2015 Delcam. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataFetcher {
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func studentList() -> [Student] {
        return []
    }
}