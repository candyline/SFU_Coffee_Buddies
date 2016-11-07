//
//  ProfileSetupViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
//
//  Team : Group3Genius
//
//  Changelog:
//      -File Created and Fundamental Functions Implemented
//
//  Known Bugs:
//      - Save button doesn't work if not tapped out from a text field
//      - Save button doesn't store the data on the database
//      - Profile edit doesn't save the profile fields because there is no database

import UIKit
//import DLRadioButton

var globalname : String = ""
var globalmajor : String = ""
var globalbusroute : String = ""
var globalinterest : String = ""
var globalbio : String = ""
var globalgender : String = "male"
var globalpicture : UIImage? = nil

class ProfileSetupViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate,
                                  UITextFieldDelegate,
                                  UITextViewDelegate,
                                  UIPickerViewDelegate
{

    // Variables and Outlets
    // Array for majors and bus routes
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var busRouteTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var interestTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var busRouteDropDown: UIPickerView!
    @IBOutlet weak var majorDropDown: UIPickerView!
    var name = ""
    var gender = "male"
    var interest = ""
    var bio = ""
    var busRoute = ""
    var major = ""
    var busList = ["135", "143", "144" ,"145"]
    var majorList = ["Actuarial Science", "Anthropology", "Applied Mathematics", "Applied Physics", "Archeology", "Art,Performance and Cinema Studies", "Behavioural Neuroscience", "Biological Physics", "Biological Sciences", "Biomedical Physiology", "Business", "Chemical Physics", "Chemistry", "Cognitive Science", "Communication", "Computing Science", "Criminology", "Dance", "Earth Sciences", "Economics", "Engineering Science", "English", "Environment One", "Environmental Resource Management", "Environmental Science", "Environmental Specialty", "Film", "First Nations Study", "French", "French Cohort Program", "Gender, Sexuality and Women's Studies", "General Studies in Education", "Geographic Information Science", "Geography", "Global Environmental Systems", "Health Sciences", "History", "Humanities", "Interactive Arts and Technology", "International Studies", "Kinesiology", "Linguistics", "Management and System Science", "Mathematical Physics", "Mathematics", "Mechatronic Systems Engineering", "Molecular Biology and Biochemistry", "Music", "Operations Research", "Philosophy", "Resource and Environmental Management", "Sociology", "Software Systems", "Statistics", "Theatre", "Visual Art", "World Literature"]
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    // Purpose : The action that happens when the button is tapped
    //           Allows the user to select a picture from their photo library
    @IBAction func selectProfilePictureTapped(_ sender: AnyObject)
    {
        let iPickerController = UIImagePickerController()
        iPickerController.delegate = self
        iPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(iPickerController, animated: true, completion: nil)
    }
    
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the border and color of the text view
        interestTextField.layer.cornerRadius = 8.0
        interestTextField.layer.borderColor = UIColor.black.cgColor
        interestTextField.layer.borderWidth = 0.8
        
        bioTextView.layer.cornerRadius = 8.0
        bioTextView.layer.borderColor = UIColor.black.cgColor
        bioTextView.layer.borderWidth = 0.8
        
        busRouteDropDown.layer.cornerRadius = 8.0
        busRouteDropDown.layer.borderColor = UIColor.black.cgColor
        busRouteDropDown.layer.borderWidth = 0.8
        
        majorDropDown.layer.cornerRadius = 8.0
        majorDropDown.layer.borderColor = UIColor.black.cgColor
        majorDropDown.layer.borderWidth = 0.8
        
        // Assign Delegates
        nameTextField.delegate = self
        interestTextField.delegate = self
        bioTextView.delegate = self
        busRouteTextField.delegate = self
        majorTextField.delegate = self
        
        busRouteDropDown.delegate = self
        majorDropDown.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileSetupViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        majorDropDown.isHidden = true
        busRouteDropDown.isHidden = true
        
        // Adds Observer for the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Purpose : Overrided public function in the UIImagePickerDelegate
    //           Dictates what happens after the image is picked
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // Image will be set to the UIImageView on the view controller
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        globalpicture = profilePictureImageView.image
        // Store the image in the db
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
    // Creator : Daniel Tan
    // Purpose : Stores the variable whenever the switch switches
    @IBAction func switched(_ sender: UISegmentedControl)
    {
        switch SegmentedControl.selectedSegmentIndex
        {
        case 0:
            gender = "male"
        
        case 1:
            gender = "female"
            
        default:
            break
        }
        globalgender = gender
    }
    
    // Creator : Daniel Tan
    // Purpose : function that determines what happens when the user taps away from the textfield
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        interestTextField.resignFirstResponder()
        bioTextView.resignFirstResponder()
        nameTextField.resignFirstResponder()
        majorTextField.resignFirstResponder()
        busRouteTextField.resignFirstResponder()
    }
    
    //This function saves the data it got from user to database when
    //user tap on the save button
    //Author: Daniel Tan
    //Las Modify Author: Eton Kan
    //Last Modify Date: Nov 6,2016
    //Known Bugs: Unable to POST data to database
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        // Store the information on the DB
        /*
        let Serverhost = URL(string: "http://127.0.0.1:8080/messages/")
        let userUser = "&user="+globalname
        //print(userUser)
        let userPass = "&password="+globalpw
        //print(userPass)
        let userGender = "&gender="+globalgender
        //print(userGender)
        let userText = "&text="+globalbio
        //print(userText)
        var postData = NSMutableData(data: "meeting=true".data(using: String.Encoding.utf8)!)
        postData.append(userUser.data(using: String.Encoding.utf8)!)
        postData.append(userPass.data(using: String.Encoding.utf8)!)
        postData.append(userGender.data(using: String.Encoding.utf8)!)
        postData.append(userText.data(using: String.Encoding.utf8)!)
        let headers = [
                    "content-type": "application/x-www-form-urlencoded",
                    "authorization": "Basic Og==",
                    "cache-control": "no-cache",
                    "postman-token": "57360440-8cde-0e19-314a-edc1975c4b7f"
                ]
        
                let request = NSMutableURLRequest(url: Serverhost!,                                          cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data
        
                let session = URLSession.shared
              let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                        if (error != nil) {
                                print(error)
                            } else {
                            let httpResponse = response as? HTTPURLResponse
                                print(httpResponse)
                            }
                    })
                
                   dataTask.resume()
         */
    }
    
    // Creator : Daniel Tan
    // Purpose : Condition Activated Segue for the save button
    //           go to the next view (profile page) after checking if all fields are filled in
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "saveProfile")
        {
            // check if any field is empty
            if (name == "" || busRoute == "" || gender == "" || major == "" || interest == "" || bio == ""){
                return false
            }
                
            else{
                return true
            }
        }
        else {
            return true
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : Implementing the optional functions to handle what the textField does, it resigns the first responder thus hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // Creator : Daniel Tan
    // Purpose : Implementing the optional functions to handle what the textField does when it ends editting
    //           read which text field and stores the text from that field into the corresponding variable
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        name = nameTextField.text!
        globalname = name
        
    }
    
    // Creator : Daniel Tan
    // Purpose : Implementing the optional functions to handle what the textView does when it ends editting
    //           read which text view and stores the text from that view into the corresponding variable
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView == interestTextField)
        {
            interest = interestTextField.text
            globalinterest = interest
        }
        else
        {
            bio = bioTextView.text
            globalbio = bio
        }
    }
    
    // Purpose : overrided function to assign how many components in the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // Purpose : overrided function that returns the number of rows in a picker view according to the list that populates it
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (pickerView == busRouteDropDown)
        {
            return busList.count
        }
        else
        {
            return majorList.count
        }
    }
    
    // Purpose : overrided optional func from delegates that will return the value of the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.view.endEditing(true)
        if (pickerView == busRouteDropDown)
        {
            return busList[row]
        }
        else
        {
            return majorList[row]
        }
    }
    
    // Purpose : overrided function called when the user selects a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView == busRouteDropDown)
        {
            // Assign the text field to the returned value
            // Hide the picker view
            busRouteTextField.text = busList[row]
            busRouteDropDown.isHidden = true
            busRoute = busRouteTextField.text!
            globalbusroute = busRoute
        }
        else if (pickerView == majorDropDown)
        {
            // Assign the text field to the returned value
            // Hide the picker view
            majorTextField.text = majorList[row]
            majorDropDown.isHidden = true
            major = majorTextField.text!
            globalmajor = major
        }
        
    }
   
    // Purpose : overrided public function that is called when the user starts editting the text field
    //           shows the picker view when the user starts "editting" the text field
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == busRouteTextField) {
            busRouteDropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        else if (textField == majorTextField){
            majorDropDown.isHidden = false
            
            textField.endEditing(true)
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : When the keyboard pops up, the view will move up so the user can see the text view it is blocking
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    // Creator : Daniel Tan
    // Purpose : When the keyboard is retracted, will move the view back to the original position
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
}
