//
//  AddGroup.swift
//  GroupTables
//
//  Created by Александр Мильчевский on 13.11.14.
//  Copyright (c) 2014 Milchevskiy Pogrebnyak. All rights reserved.
//

import UIKit

class AddGroup: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var GroupNameField: UITextField!
    @IBOutlet weak var SpecialityField: UITextField!
    @IBOutlet weak var CoursePicker: UIPickerView!
    
    let PickerCourse = [["1","2","3","4","5"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoursePicker.delegate = self
        CoursePicker.dataSource = self

    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PickerCourse.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerCourse[component].count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return PickerCourse[component][row]
    }

    @IBAction func CancelButton(sender: UIBarButtonItem) {
         self.performSegueWithIdentifier("not", sender: self)
    }

    @IBAction func AddButton(sender: UIBarButtonItem) {
        if (GroupNameField.text? != ""){

            performSegueWithIdentifier("AddSeq", sender: self)
            
        }else {
            var alert = UIAlertController(title: "Nope", message: "You must enter correct values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Alrighty then", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "AddSeq" {
            var vc = segue.destinationViewController as ViewController
            vc.name = GroupNameField.text
            vc.spec = SpecialityField.text
            vc.course = PickerCourse[0][CoursePicker.selectedRowInComponent(0)]
        }
    }
}
