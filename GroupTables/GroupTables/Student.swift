//
//  Student.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 14.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import Foundation
import CoreData

class Student: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var surname: String
    @NSManaged var personalcode: String
    @NSManaged var stud_group: NSNumber
    @NSManaged var rel_group: GroupTables.Group
    
    class func addNewStudent(moc: NSManagedObjectContext,Name: String, Surname: String, PersCode: String, StudGroup: Group)-> Student{
        let newStud = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: moc) as Student
        newStud.name = Name
        newStud.surname = Surname
        newStud.personalcode = PersCode
        newStud.stud_group = StudGroup.id
        newStud.rel_group = StudGroup
        return newStud
    }
}
