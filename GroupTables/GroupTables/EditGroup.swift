//
//  EditGroup.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 19.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit
import CoreData

class EditGroup: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var SpecField: UITextField!
    @IBOutlet weak var CourseField: UITextField!
    
    var groupEdit : Group?
    var Groups = [Group]()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameField.text = groupEdit?.groupName
        SpecField.text = groupEdit?.speciality
        CourseField.text = groupEdit?.course
        
        NameField.delegate = self
        SpecField.delegate = self
        CourseField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        NameField.resignFirstResponder()
        SpecField.resignFirstResponder()
        CourseField.resignFirstResponder()
        if CheckFields(){
            fetchGroup()
        } else{
            var alert = UIAlertController(title: "Nope", message: "You must enter correct values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Alrighty then", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return true
    }
    
    func fetchGroup() {
        
        let fetchRequest = NSFetchRequest(entityName: "Group")
        let studPredicate = NSPredicate(format: "groupName = %@", groupEdit!.groupName)
        fetchRequest.predicate = studPredicate
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Group] {
            Groups = fetchResults
            Groups[0].groupName = NameField.text
            Groups[0].speciality = SpecField.text
            Groups[0].course = CourseField.text
            
        }
    }
    
    func CheckFields()->Bool{
        if (NameField.text != " "&&NameField != nil&&NameField != ""){
            if (SpecField.text != " "&&SpecField != nil&&SpecField != ""){
                if (CourseField.text != " "&&CourseField != nil&&CourseField != ""){
                    return true
                }
            }
        }
        return false
    }
}
