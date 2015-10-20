//
//  DetailViewController.swift
//  RecruitSheets
//
//  Created by Zhihao Cui on 19/10/2015.
//  Copyright © 2015 Delcam. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, CheckboxDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet var selectTitleButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var contactNumberTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var graduationYearTextField: UITextField!
    @IBOutlet var intendedStartDateButton: UIButton!
    @IBOutlet var forSoftwareCheckBox: Checkbox!
    @IBOutlet var forApplicationEngineerCheckBox: Checkbox!
    @IBOutlet var forMarketingCheckBox: Checkbox!
    @IBOutlet var forSummerInternCheckBox: Checkbox!
    @IBOutlet var forYearPlacementCheckBox: Checkbox!
    @IBOutlet var forGraduateSchemeCheckBox: Checkbox!
    @IBOutlet var staffNoteTextField: UITextView!
    @IBOutlet var staffCheckBox: Checkbox!
    @IBOutlet var staffCheckLabel: UILabel!
    
    var titlePicker : UIPickerView!
    var titlePickerToolBar : UIToolbar!
    var viewForTitlePicker : UIView!
    
    let selectTitleList = ["Select Title", "Mr", "Miss", "Mrs", "Ms", "Dr"]

    var startDatePicker : UIDatePicker!
    var startDatePickerToolBar : UIToolbar!
    var viewForStartDatePicker : UIView!
    
    let defaultPickerHeight : CGFloat = 270
    let defaultToolbarHeight : CGFloat = 44
    
    // For move textField when keyboard shows
    var keyboardHeight : CGFloat = 398
    var viewMoved : CGFloat = 0

    var studentDetail: Student?
    
    func setDetail() {
        if let student = studentDetail {
            forYearPlacementCheckBox.selected = student.forOneYearPlacement as! Bool
            forSoftwareCheckBox.selected = (student.forSoftwareEngineer?.boolValue)!
            forSummerInternCheckBox.selected = (student.forSummerIntern?.boolValue)!
            forApplicationEngineerCheckBox.selected = (student.forApplicationEngineer?.boolValue)!
            forMarketingCheckBox.selected = (student.forMarketing?.boolValue)!
            forGraduateSchemeCheckBox.selected = (student.forGraduateScheme?.boolValue)!
            
            selectTitleButton.setTitle(student.title, forState: UIControlState.Normal)
            lastNameTextField.text = student.lastName
            firstNameTextField.text = student.firstName
            emailTextField.text = student.email
            contactNumberTextField.text = student.contactNumber
            graduationYearTextField.text = student.graduationYear
            majorTextField.text = student.major
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateStyle = .MediumStyle
            timeFormatter.timeStyle = .NoStyle
            intendedStartDateButton.setTitle(timeFormatter.stringFromDate((student.intendedStartingDate)!), forState: UIControlState.Normal)
            
            staffNoteTextField.text = student.staffNote
            staffCheckBox.selected = (student.staffCheck?.boolValue)!
            staffCheckBox.hidden = false
            staffNoteTextField.hidden = false
            staffCheckLabel.hidden = false

        }
    }
    
    func clearFields() {
       
        forYearPlacementCheckBox.selected = false
        forSoftwareCheckBox.selected = false
        forSummerInternCheckBox.selected = false
        forApplicationEngineerCheckBox.selected = false
        forMarketingCheckBox.selected = false
        forGraduateSchemeCheckBox.selected = false
        
        selectTitleButton.setTitle(selectTitleList[0], forState: UIControlState.Normal)
        lastNameTextField.text = ""
        firstNameTextField.text = ""
        emailTextField.text = ""
        contactNumberTextField.text = ""
        graduationYearTextField.text = ""
        majorTextField.text = ""
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .NoStyle
        intendedStartDateButton.setTitle(timeFormatter.stringFromDate(NSDate()), forState: UIControlState.Normal)
        
        staffNoteTextField.text = "-- Staff Use --"
        staffCheckBox.selected = false
        staffNoteTextField.hidden = true
        staffCheckBox.hidden = true
        staffCheckLabel.hidden = true
    }

    func configureView() {
        // Navigation Bar Done Button
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneNavigationButtonTapped:"),animated: true)
        
        forSoftwareCheckBox.mDelegate = self
        forSoftwareCheckBox.set("forSoftwareCheckBox", selected: false)
        forSummerInternCheckBox.mDelegate = self
        forSummerInternCheckBox.set("forSummerInternCheckBox", selected: false)
        forYearPlacementCheckBox.mDelegate = self
        forYearPlacementCheckBox.set("forYearPlacementCheckBox", selected: false)
        forGraduateSchemeCheckBox.mDelegate = self
        forGraduateSchemeCheckBox.set("forGraduateSchemeCheckBox", selected: false)
        forApplicationEngineerCheckBox.mDelegate = self
        forApplicationEngineerCheckBox.set("forApplicationEngineerCheckBox", selected: false)
        forMarketingCheckBox.mDelegate = self
        forMarketingCheckBox.set("forMarketingCheckBox", selected: false)
        staffCheckBox.mDelegate = self
        staffCheckBox.set("staffCheckBox", selected: false)
        
        let viewFrame : CGRect = view.frame
        
        viewForTitlePicker = UIView(frame: CGRectMake(0, viewFrame.size.height, viewFrame.size.width, defaultPickerHeight + defaultToolbarHeight - 2))
        
        titlePicker = UIPickerView(frame: CGRectMake(0, defaultToolbarHeight - 2, viewForTitlePicker.frame.size.width, defaultPickerHeight))
        titlePicker.delegate = self
        titlePicker.dataSource = self
        titlePicker.showsSelectionIndicator = true
        
        titlePickerToolBar = UIToolbar(frame: CGRectMake(0, 0, viewForTitlePicker.frame.size.width, defaultToolbarHeight + 5))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneTitleSelectionButtonTapped:")
        titlePickerToolBar.setItems([flexSpace, doneButton], animated: true)
        
        viewForTitlePicker.addSubview(titlePicker)
        viewForTitlePicker.addSubview(titlePickerToolBar)
        
        viewForStartDatePicker = UIView(frame: CGRectMake(0, viewFrame.size.height, viewFrame.size.width, defaultPickerHeight + defaultToolbarHeight - 2))
        
        startDatePicker = UIDatePicker(frame: CGRectMake(0, defaultToolbarHeight - 2, viewForStartDatePicker.frame.size.width, defaultPickerHeight))
        startDatePicker.datePickerMode = .Date
        startDatePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
        
        datePickerChanged(startDatePicker)
        
        startDatePickerToolBar = UIToolbar(frame: CGRectMake(0, 0, viewForStartDatePicker.frame.size.width, defaultToolbarHeight + 5))
        
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneDateSelectionButtonTapped:")
        startDatePickerToolBar.setItems([flexSpace, dateDoneButton], animated: true)
        
        viewForStartDatePicker.addSubview(startDatePicker)
        viewForStartDatePicker.addSubview(startDatePickerToolBar)
        
        staffNoteTextField.layer.borderColor = UIColor.grayColor().CGColor
        staffNoteTextField.layer.borderWidth = 1.0
        staffNoteTextField.layer.cornerRadius = 5.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if let _ = studentDetail {
            setDetail()
        } else {
            clearFields()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Picker View Delegate and Datasource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectTitleList[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectTitleList.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //MARK: -
    func didSelectCheckbox(state: Bool, identifier: Int, title: String) {
        print("checkbox '\(title)' has state \(state)");
    }

    @IBAction func selectTitleButtonTapped(sender: UIButton) {
        showTitlePicker()
    }
    @IBAction func intendedStartDateButtonTapped(sender: UIButton) {
        showDatePicker()
    }

    
    // MARK: - Utilities
    func showTitlePicker () {
        hideDatePicker()
//        titlePicker.reloadAllComponents()
        
        titlePicker.selectRow(selectTitleList.indexOf(selectTitleButton.currentTitle!)!, inComponent: 0, animated: true)
        view.addSubview(viewForTitlePicker)
        
        resetTitlePickerViewFrame()
        
        UIView.animateWithDuration(0.5, animations: {
            self.viewForTitlePicker.frame.origin.y -= self.viewForTitlePicker.frame.size.height
        })
    }
    
    func hideTitlePicker () {
        UIView.animateWithDuration(0.5, animations: {
            self.viewForTitlePicker.frame.origin.y += self.viewForTitlePicker.frame.size.height
        })
        viewForTitlePicker.removeFromSuperview()
    }
    
    func resetTitlePickerViewFrame () {
        let viewFrame : CGRect = view.frame
        
        viewForTitlePicker.frame = CGRectMake(0, viewFrame.size.height, viewFrame.size.width, defaultPickerHeight + defaultToolbarHeight)
        
        titlePicker.frame = CGRectMake(0, defaultToolbarHeight, viewForTitlePicker.frame.size.width, defaultPickerHeight)
        titlePickerToolBar.frame = CGRectMake(0, 0, viewForTitlePicker.frame.size.width, defaultToolbarHeight)
    }
    
    func showDatePicker () {
        hideTitlePicker()
        resetDatePickerViewFrame()
        
        view.addSubview(viewForStartDatePicker)
        
        UIView.animateWithDuration(0.5, animations: {
            self.viewForStartDatePicker.frame.origin.y -= self.viewForStartDatePicker.frame.size.height
        })
    }
    
    func hideDatePicker () {
        UIView.animateWithDuration(0.5, animations: {
            self.viewForStartDatePicker.frame.origin.y += self.viewForStartDatePicker.frame.size.height
        })
        viewForStartDatePicker.removeFromSuperview()
    }
    
    func resetDatePickerViewFrame () {
        let viewFrame : CGRect = view.frame
        
        viewForStartDatePicker.frame = CGRectMake(0, viewFrame.size.height, viewFrame.size.width, defaultPickerHeight + defaultToolbarHeight)
        
        startDatePicker.frame = CGRectMake(0, defaultToolbarHeight, viewForStartDatePicker.frame.size.width, defaultPickerHeight)
        startDatePickerToolBar.frame = CGRectMake(0, 0, viewForStartDatePicker.frame.size.width, defaultToolbarHeight)
    }
    
    //MARK: - Core Data
    
    func saveToCoreData() -> Bool {
        if studentDetail == nil {
            insertNewStudent()
        } else {
            updateStudent()
        }
        
        return saveContext()
    }
    
    func insertNewStudent() {
        let newStudent = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: managedObjectContext) as! Student
        
        setStudent(newStudent)
        
        studentDetail = newStudent
    }
    
    func updateStudent() {
        setStudent(studentDetail!)
    }
    
    func setStudent(student: Student) {
        student.lastName = lastNameTextField.text
        student.firstName = firstNameTextField.text
        student.timeStamp = NSDate()
        student.graduationYear = graduationYearTextField.text
        student.major = majorTextField.text
        student.contactNumber = contactNumberTextField.text
        student.email = emailTextField.text
        student.title = selectTitleButton.currentTitle
        student.forApplicationEngineer = forApplicationEngineerCheckBox.selected
        student.forGraduateScheme = forGraduateSchemeCheckBox.selected
        student.forMarketing = forMarketingCheckBox.selected
        student.forSummerIntern = forSummerInternCheckBox.selected
        student.forOneYearPlacement = forYearPlacementCheckBox.selected
        student.forSoftwareEngineer = forSoftwareCheckBox.selected
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .NoStyle
        student.intendedStartingDate = timeFormatter.dateFromString(intendedStartDateButton.currentTitle!)
        
        student.staffCheck = staffCheckBox.selected
        student.staffNote = staffNoteTextField.text
    }
    
    func saveContext () -> Bool {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                return true
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                showAlertWithTitle("Error", message: "Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        } else {
            return true
        }
    }
    
    
    //MARK: - Button events
    
    func doneTitleSelectionButtonTapped (sender: UIBarButtonItem) {
        // Get Selected Pharmacy
        let selectedRow = titlePicker.selectedRowInComponent(0)
        
        selectTitleButton.setTitle(selectTitleList[selectedRow], forState: .Normal)
        
        hideTitlePicker()
    }
    
    func doneDateSelectionButtonTapped (sender: UIBarButtonItem) {
        hideDatePicker()
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .NoStyle
        intendedStartDateButton.setTitle(timeFormatter.stringFromDate(sender.date), forState: UIControlState.Normal)
    }
    
    func doneNavigationButtonTapped(sender: UIBarButtonItem) {
        if lastNameTextField.text?.isEmpty == false && firstNameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false {
            if (saveToCoreData() == true) {
                showAlertWithTitle("Saved", message: "Thank you.")
            }
        }
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

