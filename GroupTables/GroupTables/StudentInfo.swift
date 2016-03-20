//
//  StudentInfo.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 14.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit
import CoreData

class StudentInfo: UIViewController, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var Name : String?
    var Surname : String?
    var GroupName : String?
    var Course : String?
    var Speciality : String?
    var Stud : Student?
    var Groups = [String]()
    var GroupsID = [NSNumber]()
    var GroupData = [[""]]
    var GroupID = [[]]
    
    
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var SurnameField: UITextField!
    @IBOutlet weak var SpecialityField: UITextField!
    @IBOutlet weak var CourseField: UITextField!
    @IBOutlet weak var PersonalCodeField: UITextField!
    @IBOutlet weak var GroupField: UITextField!
    @IBOutlet weak var GroupPicker: UIPickerView!
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    func loadGroups() -> [String]{
        let fetchRequest = NSFetchRequest(entityName: "Group")
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Group]
        for grps in fetchResult!{
            Groups.append(grps.groupName)
            GroupsID.append(grps.id)
        }
        return Groups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupData = [loadGroups()]
        GroupID = [GroupsID]
        GroupPicker.delegate = self
        GroupPicker.dataSource = self
        NameField.text = Stud?.name
        SurnameField.text = Stud?.surname
        PersonalCodeField.text = Stud?.personalcode
        SpecialityField.text = Speciality
        CourseField.text = Course
        GroupField.text = GroupName
        NameField.delegate = self
        SurnameField.delegate = self
        PersonalCodeField.delegate = self
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return GroupData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GroupData[component].count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return GroupData[component][row]
    }
    @IBAction func DoneEditing(sender: UIBarButtonItem) {
        let vc = Students(nibName: "Students" , bundle: nil)
        vc.takenGroup = Stud!.rel_group
        navigationController?.pushViewController(vc, animated: true)
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fetchRequest = NSFetchRequest(entityName: "Student")
        let studPredicate = NSPredicate(format: "personalcode = %@", Stud!.personalcode)
        fetchRequest.predicate = studPredicate
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Student] {
            fetchResults[0].stud_group = GroupID[0][GroupPicker.selectedRowInComponent(0)] as NSNumber
        }

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        NameField.resignFirstResponder()
        SurnameField.resignFirstResponder()
        PersonalCodeField.resignFirstResponder()
        if CheckFields(){
        fetchStudents()
        } else{
            var alert = UIAlertController(title: "Nope", message: "You must enter correct values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Alrighty then", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return true
    }
    
    func fetchStudents() {
        
        let fetchRequest = NSFetchRequest(entityName: "Student")
        let studPredicate = NSPredicate(format: "personalcode = %@", Stud!.personalcode)
        fetchRequest.predicate = studPredicate
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Student] {
            fetchResults[0].name = NameField.text
            fetchResults[0].surname = SurnameField.text
            fetchResults[0].personalcode = PersonalCodeField.text
        }
    }
    
    func CheckFields()->Bool{
        if (NameField.text != " "&&NameField != nil&&NameField != ""){
            if (SurnameField.text != " "&&SurnameField != nil&&SurnameField != ""){
                if (PersonalCodeField.text != " "&&PersonalCodeField != nil&&PersonalCodeField != ""){
                    return true
                }
            }
        }
        return false
    }

}
