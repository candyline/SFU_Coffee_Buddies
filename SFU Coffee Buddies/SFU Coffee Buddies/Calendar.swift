//  File Name: Calendar.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Dec 1, 2016
//  List of Changes:
//  V1.0: Created by Eton Kan
//  V1.1: Able to add calender event to user's calender
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
//
//  List of Bugs: none
//
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import EventKit

//Calendar Functions are located in this class (add)
//Author: Eton Kan
//Last Modifty: Nov 6,2016
class Calendar: UIViewController,
                UIImagePickerControllerDelegate,
                UINavigationControllerDelegate,
                UITextFieldDelegate,
                UITextViewDelegate,
                UIPickerViewDelegate
    
{
    var meetingAndCoffee: String = "Coffee Meeting with "
    var location = "" //ASB Renaissance or AQ Renaissance
    var locationList = ["ASB", "AQ"]
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var eventStartDatePicker: UIDatePicker!
    @IBOutlet var eventEndDatePicker: UIDatePicker!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var locationDropDown: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        
        locationDropDown.layer.cornerRadius = 8.0
        locationDropDown.layer.borderColor = UIColor.black.cgColor
        locationDropDown.layer.borderWidth = 0.8
        
        locationDropDown.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileSetupViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        locationDropDown.isHidden = true
    }
    // Purpose : overrided function to assign how many components in the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // Purpose : overrided function that returns the number of rows in a picker view according to the list that populates it
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return locationList.count
    }
    
    // Purpose : overrided optional func from delegates that will return the value of the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.view.endEditing(true)
        return locationList[row]
    }
    
    // Purpose : overrided function called when the user selects a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // Assign the text field to the returned value
        // Hide the picker view
        locationTextField.text = locationList[row]
        locationDropDown.isHidden = true
        self.location = locationTextField.text!
    }
 
    // Purpose : overrided public function that is called when the user starts editting the text field
    //           shows the picker view when the user starts "editting" the text field
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        locationDropDown.isHidden = false
        textField.endEditing(true)
    }
    
    @IBAction func submit(_ sender: UIButton)
    {
        let msgTitle = meetingAndCoffee + targetProfile.username
        let msgDescription = "Meeting at " + location + " Renaissance"
        
        addEventToCalendar(title: msgTitle, description: msgDescription, startDate: eventStartDatePicker.date as NSDate, endDate: eventEndDatePicker.date as NSDate)
        //Return to main page after creating an event in user's calender
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        self.present(vc, animated:true, completion: nil)
    }

    //Setting an event to user's calendar
    //Author: Eton Kan
    //Last Modify: Dec 1,2016
    //Known Bugs: none
    func addEventToCalendar(title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((_ success: Bool, _ error: NSError) -> Void)? = nil)
    {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion:
        {
            (granted, error) in
            if (granted) && (error == nil)
            {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(EKAlarm(absoluteDate: event.startDate))
                
                do
                {
                    try eventStore.save(event, span: .thisEvent)
                }
                catch let e as NSError
                {
                    completion?(false, e)
                    return
                }
            }
        })
    }
}

