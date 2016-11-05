//
//  LoginViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var username = ""
    var password = ""
    
    @IBOutlet weak var incorrectMessageLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the incorrect message label
        incorrectMessageLabel.isHidden = true
        
        // Handle the text field's user input through delegate callbacks
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        username = usernameTextField.text!
        password = passwordTextField.text!
    }
    
    // Condition Activated Segue for the login
    // If wrong user/pass = display message, else perform the segue to the main menu
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "LoginSuccessful")
        {
            // change this later based on validating off the database stored user and pws
            if (username == "test"){
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
