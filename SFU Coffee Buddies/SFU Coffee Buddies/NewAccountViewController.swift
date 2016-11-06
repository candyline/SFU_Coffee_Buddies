//
//  NewAccountViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController, UITextFieldDelegate {

    var email = ""
    var pw = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        pwTextField.delegate = self
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(NewAccountViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        incorrectEmailLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var incorrectEmailLabel: UITextView!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }*/
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if (textField == emailTextField)
        {
            email = emailTextField.text!
        }
        else
        {
            pw = pwTextField.text!
        }
    }

    @IBAction func submitEmailPressed(_ sender: UIButton) {
        // 1 - Check if valid email maybe? just @ something.com
        // 2 - somehow make a script to send emails to them
    }
    
    // go to the next view (code confirmation page) after checking for valid emails
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "SubmitEmail")
        {
            // if (emailIsValid)
            //    return true
            // else
            //    return false
            if (email.hasSuffix("@sfu.ca"))
            {
                return true
            }
            else
            {
                incorrectEmailLabel.isHidden = false
                return false
            }
        }
        else {
            return true
        }
    }
    
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        emailTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
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
