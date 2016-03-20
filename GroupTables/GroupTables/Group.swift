//
//  Group.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 13.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import Foundation
import CoreData

class Group: NSManagedObject {

    @NSManaged var groupName: String
    @NSManaged var speciality: String
    @NSManaged var course: String
    @NSManaged var id: NSNumber
    
    
    
    class func addNewGroup(moc: NSManagedObjectContext,GroupName: String, Spec: String, Course: String)-> Group{
        
        var newId = Int(arc4random())
        let fetchRequest = NSFetchRequest(entityName: "Group")
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Group] {
            for group in fetchResults{
                if group.id == newId{
            newId = Int(arc4random())
                }
            }
        }
        let newGroup = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: moc) as Group
        newGroup.groupName = GroupName
        newGroup.course = Course
        newGroup.speciality = Spec
        newGroup.id = newId
        return newGroup
    }
    
    func showcourse()-> String{
       return self.course
    }
    
}
