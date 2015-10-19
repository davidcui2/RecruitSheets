//
//  Student+CoreDataProperties.swift
//  RecruitSheets
//
//  Created by Zhihao Cui on 20/10/2015.
//  Copyright © 2015 Delcam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var contactNumber: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var forApplicationEngineer: NSNumber?
    @NSManaged var forGraduateScheme: NSNumber?
    @NSManaged var forMarketing: NSNumber?
    @NSManaged var forOneYearPlacement: NSNumber?
    @NSManaged var forSoftwareEngineer: NSNumber?
    @NSManaged var forSummerIntern: NSNumber?
    @NSManaged var graduationYear: String?
    @NSManaged var intendedStartingDate: NSDate?
    @NSManaged var lastName: String?
    @NSManaged var major: String?
    @NSManaged var staffCheck: NSNumber?
    @NSManaged var staffNote: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var title: String?

}
