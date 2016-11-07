//
//  LoginViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
//  Team : Group3Genius
//
//  Changelog:
//      -File Created and Fundamental Functions Implemented
//
//  Known Bugs:
//      - username and password fields don't read from database because database isn't done yet - November 6
//      - can't press button to login unless tapped away (first responder resigned) - November 6

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    // Outlets and variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var username = ""
    var password = ""
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
    
    // Creator : Daniel Tan
    // Purpose : When the user presses the login button, will post to the databse
    //           Might not need this as we might do it on the  segue change instead of button press
    @IBAction func loginPressed(_ sender: UIButton)
    {
        // check database for the variable and match the username password
        // Yet to implement
        // if valid username/password combo proceed to next screen
        // if (databaseUsernamePWcomboExist = true)
        // go to next page
        
        /*if (username == "danieltzj")
        {
            // move onto next viewController when login is successful
            performSegue(withIdentifier: "LoginSuccessful", sender: self)
        }
        else
        {
            // Display an incorrect user/password combo message and prompt to retry
            incorrectMessageLabel.isHidden = false
        }*/
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
    // Purpose : Condition Activated Segue for the login
    //           If wrong user/pass = display message, else perform the segue to the main menu
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "LoginSuccessful")
        {
            // change this later based on validating off the database stored user and pws
            if (username == "dzt2" && password == "hunter2"){
                return true
            }
        
            else{
                incorrectMessageLabel.isHidden = false
                return false
            }
        }
        else {
            return true
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : function that determines what happens when the user taps away from the textfield
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
