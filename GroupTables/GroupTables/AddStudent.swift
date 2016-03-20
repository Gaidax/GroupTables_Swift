//
//  AddStudent.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 15.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit

protocol GroupDelegate{
    func DidSendGroup(controller:AddStudent)
}

class AddStudent: UIViewController {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var SurnameField: UITextField!
    @IBOutlet weak var CodeField: UITextField!
    
    var takenGroup : Group?
    var storyInd : UIStoryboard?
    var delegate:GroupDelegate!=nil
    
    @IBAction func AddStudButton(sender: UIBarButtonItem) {
        if isFilled(){
        let vc = Students(nibName: "Students", bundle: nil)
        vc.addName = NameField.text
        vc.addSurname = SurnameField.text
        vc.addCode = CodeField.text
        delegate.DidSendGroup(self)
        vc.takenGroup = takenGroup
        vc.storyInd = storyInd
        let contr : UINavigationController = self.navigationController!
        navigationController?.popViewControllerAnimated(false)
        contr.pushViewController(vc, animated: true)
        } else{
            var alert = UIAlertController(title: "Nope", message: "You must enter correct values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Alrighty then", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func Cancel(sender: UIBarButtonItem) {
        navigationController?.navigationBarHidden = true
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func BackToRoot(sender: UIButton) {
        self.performSegueWithIdentifier("backroot", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func isFilled()->Bool{
        if let s = NameField.text?{
            if let s = SurnameField.text?{
                if let s = CodeField.text?{
                    return true
                }
            }
        }
        return false
    }
    

}
