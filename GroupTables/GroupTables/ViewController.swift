//
//  ViewController.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 13.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet
    var tableView: UITableView!
    var Groups = [Group]()
    var name : String?
    var spec : String?
    var course : String?
    var editableGroup : Group?
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    @IBAction func LongPressEdit(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began{
        let p : CGPoint = sender.locationInView(tableView)
        let path : NSIndexPath = tableView.indexPathForRowAtPoint(p)!
        editableGroup = Groups[path.row]
        performSegueWithIdentifier("edit", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.userInteractionEnabled = true
        if let s = name?{
            addNewGroup(name!, groupspec: spec!, groupcource: course!)
            var backButton: UIBarButtonItem = UIBarButtonItem(title: "CUSTOM", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
            navigationItem.setHidesBackButton(true, animated: true)
        }
        fetchGroups()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Groups.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let Groupcell = Groups[indexPath.row]
        cell.textLabel.text = Groupcell.groupName
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {

            let GroupToDelete = Groups[indexPath.row]
            
            managedObjectContext?.deleteObject(GroupToDelete)
            let fetchRequest = NSFetchRequest(entityName: "Student")
            let studPredicate = NSPredicate(format: "rel_group = %@", GroupToDelete)
            fetchRequest.predicate = studPredicate
            let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Student]
            for stud in fetchResults!{
                managedObjectContext?.deleteObject(stud)
            }
            fetchGroups()
            
            [tableView .deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)]
            persist()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = Students(nibName: "Students", bundle: nil)
        vc.takenGroup = Groups[indexPath.row]
        vc.storyInd = self.storyboard
        navigationController?.pushViewController(vc, animated: true)
    }
    

    func addNewGroup(groupname : String, groupspec: String, groupcource: String) {
        
        var NewGroup = Group.addNewGroup(self.managedObjectContext!, GroupName: groupname, Spec: groupspec, Course: groupcource)
        
        fetchGroups()
        
        if let newGroupIndex = find(Groups, NewGroup) {
            
            let newGroupIndexPath = NSIndexPath(forRow: newGroupIndex, inSection: 0)
            
           tableView.insertRowsAtIndexPaths([ newGroupIndexPath ], withRowAnimation: .Automatic)
            persist()
        }
    }

 
    func fetchGroups() {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        
        let sortDescriptor = NSSortDescriptor(key: "groupName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Group] {
            Groups = fetchResults
        }
    }
    
    func persist() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "edit" {
            var vc = segue.destinationViewController as EditGroup
            vc.groupEdit = editableGroup
            
        }
    }
}
