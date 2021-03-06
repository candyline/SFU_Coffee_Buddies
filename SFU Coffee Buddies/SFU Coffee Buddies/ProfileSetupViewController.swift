//  File: ProfileSetupViewController.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 29, 2016
//
//  Changelog:
//      V1.0: File Created and Fundamental Functions Implemented
//
//  Known Bugs:
//      1) Save button doesn't work if not tapped out from a text field (Fixed - Eton Nov 20)
//      2) Save button doesn't store the data on the database
//      3) Profile edit doesn't save the profile fields because there is no database
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
//
//  Copyright © 2016 CMPT275-3. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON

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
    var imageString = ""
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
        // making profile pic circular
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView.clipsToBounds = true
        
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
        
        nameTextField.addTarget(self,action: #selector(didChangeText(textField:)), for: .editingChanged)
        // Assign Delegates
        //nameTextField.delegate = self
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
        
        ProfilePageViewController().getUserProfile(urlPath: serverprofile, userEmail: userprofile.email, completionHandler:
            {
                (UIBackgroundFetchResult) -> Void in
                print("User profile ready for edit")
                if !(userprofile.username == "0" || userprofile.interest == "0" || userprofile.bio == "0" || userprofile.bus == "0" || userprofile.major == "0")
                {
                    self.nameTextField.text = userprofile.username
                    self.interestTextField.text = userprofile.interest
                    self.bioTextView.text = userprofile.bio
                    self.busRouteTextField.text = userprofile.bus
                    self.majorTextField.text = userprofile.major
                    self.gender = userprofile.gender
                    if !(userprofile.image.isEmpty || userprofile.image == "0")
                    {
                        self.profilePictureImageView.image = ProfileSetupViewController().stringToImage(userString: userprofile.image)
                        self.imageString = userprofile.image
                    }
                }
        })
    }
    
    //Putting text into their respective variables
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func didChangeText(textField: UITextField)
    {
        name = nameTextField.text!
    }
    
    //Converting profile pictures to base 64 string
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func imageToString(userImage: UIImage) -> String
    {
        let targetSize = CGSize(width: 200, height: 200)
        let size = userImage.size
        
        let widthRatio = targetSize.width / userImage.size.width
        let heightRatio = targetSize.height / userImage.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio)
        {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }
        else
        {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        userImage.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       
        let imageData = UIImageJPEGRepresentation(newImage!, 0.0)
        let base64String: String  = imageData!.base64EncodedString()
        
        return base64String
    }
    
    //Converting base 64 string to profile pictures
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func stringToImage(userString: String) ->UIImage
    {
        let dataDecoded = NSData(base64Encoded: userString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded as Data)
        return image!
    }
    
    // Purpose : Overrided public function in the UIImagePickerDelegate
    //           Dictates what happens after the image is picked
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // Image will be set to the UIImageView on the view controller
        //profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //globalpicture = profilePictureImageView.image
        globalpicture = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageString = imageToString(userImage: globalpicture!)
        profilePictureImageView.image = stringToImage(userString: imageString)
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
    
    //This function saves the data it got from user to database when user tap on the save button
    //Author: Daniel Tan
    //Las Modify Author: Eton Kan
    //Last Modify Date: Nov 11,2016
    //Known Bugs: Unable to POST data to database (Fixed Nov 12, 2016)
    //            First time cannot put information in to database (due to unable to get user id)
    @IBAction func saveProfile(_ sender: UIButton)
    {
        interest = interestTextField.text
        bio = bioTextView.text
        busRoute = busRouteTextField.text!
        name = nameTextField.text!
        major = majorTextField.text!
        
        if (globalpicture != nil)
        {
            imageString = imageToString(userImage: globalpicture!)
        }
        if !(name == "" || busRoute == "" || gender == "" || major == "" || interest == "" || bio == "")
        {
            let appendedUserUrl = serverprofile + userprofile.id
            print(appendedUserUrl)
            
            // Updating the user's information on the DB
            let parameters: [String: Any] =
            [
                    "meeting"   : "false",
                    "gender"    : self.gender,
                    "pw"        : userprofile.pw,
                    "email"     : userprofile.email,
                    "bio"       : self.bio,
                    "username"  : self.name,
                    "interest"  : self.interest,
                    "bus"       : self.busRoute,
                    "major"     : self.major,
                    "coffee"    : userprofile.coffee,
                    "blockUser" : userprofile.blockedUser,
                    "QRcode"    : userprofile.qrCode,
                    "image"     : self.imageString,
                    "coffeeCode": userprofile.coffeeCode,
                    "chatUser"  : userprofile.chatUser
            ]
            print(parameters)
            Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseString
            {
                    response in
                    switch response.result
                    {
                    case .success:
                        print("I put up")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                        self.present(vc, animated:true, completion: nil)
                        
                    case .failure(let error):
                        print(error)
                        print("Cannot put data to server")
                    }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please fill in all fields to proceed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : Condition Activated Segue for the save button
    //           go to the next view (profile page) after checking if all fields are filled in
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "saveProfile")
        {
            // check if any field is empty
            if (name == "" || busRoute == "" || gender == "" || major == "" || interest == "" || bio == "")
            {
                return false
            }
                
            else
            {
                return true
            }
        }
        else
        {
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
    // Purpose : Implementing the optional functions to handle what the textView does when it ends editting
    //           read which text view and stores the text from that view into the corresponding variable
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView == interestTextField)
        {
            interest = interestTextField.text
            //globalinterest = interest
        }
        else
        {
            bio = bioTextView.text
            //globalbio = bio
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
            //globalbusroute = busRoute
        }
        else if (pickerView == majorDropDown)
        {
            // Assign the text field to the returned value
            // Hide the picker view
            majorTextField.text = majorList[row]
            majorDropDown.isHidden = true
            major = majorTextField.text!
            //globalmajor = major
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
