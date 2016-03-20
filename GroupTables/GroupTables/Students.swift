//
//  Students.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 14.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit
import CoreData


class Students: UIViewController , UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, GroupDelegate {
    
    var Students = [Student]()
    
    var takenGroup : Group?
    var addName : String?
    var addSurname : String?
    var addCode : String?
    var storyInd : UIStoryboard?

    @IBOutlet weak var tableView: UITableView!
    
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
        navigationController?.navigationBarHidden = true
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if let s = addName?{
            addNewStudent(addName!, surname: addSurname!, perscode: addCode!, stud_gr: takenGroup!)
        }
        fetchStudents()
    }
    
    func DidSendGroup(controller:AddStudent){
        controller.takenGroup = takenGroup
        controller.storyInd = storyInd
    }
    
    
    @IBAction func AddStud(sender: UIBarButtonItem) {
        
        navigationController?.navigationBarHidden = false
        let AddStuden = storyInd!.instantiateViewControllerWithIdentifier("AddStudent") as AddStudent
        navigationController?.pushViewController(AddStuden, animated: true)
        AddStuden.delegate = self
    }
    
    @IBAction func BackToGroups(sender: UIBarButtonItem) {
        navigationController?.navigationBarHidden = false
        navigationController?.popToRootViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let Studcell = Students[indexPath.row]
    
        cell.textLabel.text = Studcell.name + " " + Studcell.surname
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
            let StudentToDelete = Students[indexPath.row]
            
            managedObjectContext?.deleteObject(StudentToDelete)
            
            self.fetchStudents()
            
            [tableView .deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)]
            persist()
           
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = StudentInfo(nibName: "StudentInfo", bundle: nil)
        vc.Stud = Students[indexPath.row]
        vc.Course = takenGroup?.course
        vc.Speciality = takenGroup?.speciality
        vc.GroupName = takenGroup?.groupName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchStudents() {
       
        let fetchRequest = NSFetchRequest(entityName: "Student")
        let groupPredicate = NSPredicate(format: "stud_group = %@", takenGroup!.id)
        fetchRequest.predicate = groupPredicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Student] {
            Students = fetchResults
        }
    }
    
    func addNewStudent(name : String, surname: String, perscode: String, stud_gr: Group) {
        
        var NewStud = Student.addNewStudent(self.managedObjectContext!, Name: name, Surname: surname, PersCode: perscode, StudGroup: stud_gr)
        
        self.fetchStudents()
        
        if let newStudIndex = find(Students, NewStud) {
            
            let newStudIndexPath = NSIndexPath(forRow: newStudIndex, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([ newStudIndexPath ], withRowAnimation: .Automatic)
            persist()
        }
    }
    func persist() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }

}
