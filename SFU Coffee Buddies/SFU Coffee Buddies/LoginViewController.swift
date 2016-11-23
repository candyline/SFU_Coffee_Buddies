//  Copyright © 2016 Daniel Tan. All rights reserved.
//
//  File Name: LoginViewController.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 29, 2016
//
//  Changelog:
//      - File Created and Fundamental Functions Implemented
//      - Grabbing data from database implemented
//      - Matching user login from database implemented
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 18, 2016
//
//  List of Bugs:
//      - username and password fields don't read from database because database isn't done yet - November 6 (Fixed - Eton Nov 18)
//      - can't press button to login unless tapped away (first responder resigned) - November 6

import UIKit
import Alamofire
import SwiftyJSON

//This classs is used to login and verify user provided email and password matched with database
//Author: Daniel Tan
//Last Modifty: Nov 18,2016
class LoginViewController: UIViewController, UITextFieldDelegate
{
    // Outlets and variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var username = ""
    var password = ""
    var expectedPassword = ""
    @IBOutlet weak var incorrectMessageLabel: UITextView!
    
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // hide the incorrect message label
        incorrectMessageLabel.isHidden = true
        
        // Handle the text field's user input through delegate callbacks
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Grabing data from the server and search user using user provided email
    //Author: Eton Kan
    //Last Modify: Nov 18,2016
    //Known Bugs: none
    func loadDetail(urlPath: String, completionHandler: ((UIBackgroundFetchResult)     -> Void)!)
    {
        var userFound = false
        print(self.username)
        //Look for user in the database with user provided email
        print("Looking for user in the database (loadDetail)")
        Alamofire.request(urlPath).responseJSON
            {
                response in
                //Testing if data available for grab
                switch response.result
                {
                case .success:
                    print("Able to connect to server and data found (loadDetail)")
                    //Parsing the data taken from server
                    let dataBaseArray = JSON(response.result.value!)
                    print(dataBaseArray)
                    //Searching for the user provided Email inside the JSON file from database
                    for index in 0 ... dataBaseArray.count
                    {
                        if let email  = dataBaseArray[index]["email"].string
                        {
                            print(email)
                            if email == self.username
                            {
                                print("User Found")
                                if let userPassword = dataBaseArray[index]["pw"].string
                                {
                                    userFound = true
                                    self.expectedPassword = userPassword
                                    completionHandler(UIBackgroundFetchResult.newData)
                                }
                            }
                        }
                    }
                    if !(userFound)
                    {
                        print("Unable to find user provided email in database (loadDetail)")
                        print("Please create a new profile (loadDetail)")
                        self.incorrectMessageLabel.isHidden = false
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        print("Background Fetch Complete (loadDetail)")
    }
    
    //Verifing user password with the database. If it is correct, user will login. If it is wrong, it will display a message to ask user to re-enter their email and password
    //Author: Eton Kan
    //Last Modify: Nov 18,2016
    //Known Bugs: none
    @IBAction func loginPressed(_ sender: UIButton)
    {
        //Verifing user provided email and password with the database
        self.loadDetail(urlPath: serverprofile, completionHandler:{(UIBackgroundFetchResult) -> Void in
            
            if self.password == self.expectedPassword
            {
                print("Correct Password and Email combo (loginPressed)")
                print("Login and go to Profile (loginPressed)")
                userProfile.email = self.username
                //Switching storyboard to main menu
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.present(vc, animated:true, completion: nil)
            }
            else
            {
                print("Wrong Password and Email combo (loginPressed)")
                print("Prompt user to re-enter password and email (loginPressed)")
                self.incorrectMessageLabel.isHidden = false
            }
        })
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
        if (textField == usernameTextField)
        {
            username = usernameTextField.text!
        }
        else
        {
            password = passwordTextField.text!
        }
    }

    // Creator : Daniel Tan
    // Purpose : function that determines what happens when the user taps away from the textfield
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
