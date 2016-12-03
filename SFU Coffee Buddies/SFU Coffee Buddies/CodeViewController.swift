//  File: CodeViewController.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 29, 2016
//
//  Changelog:
//      V1.0: File Created and Fundamental Functions Implemented
//
//  Known Bugs:
//      1) Database doesn't work, no way to verify codes - November 6
//      2) Since email sending and generating doesn't work - November 6
//
//  Last Modified Author: Daniel Tan
//  Last Modified Date: Oct 29, 2016
//
//  Copyright © 2016 CMPT275-3. All rights reserved.

import UIKit

var globalcode : String = ""

class CodeViewController: UIViewController, UITextFieldDelegate
{
    // Variables and Outlets
    var code = ""
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    @IBOutlet weak var incorrectCodeLabel: UITextView!
    
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Assign Delegates
        confirmationCodeTextField.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(CodeViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        incorrectCodeLabel.isHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        code = confirmationCodeTextField.text!
    }
    
    // Creator : Daniel Tan
    // Purpose : Condition Activated Segue for the submit button
    //           go to the next view (profile setup page) after checking for valid code
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "submitCode")
        {
            // if (codeIsCorrect)
            //    return true
            // else
            //    return false
            //    show message
            return true
            
        }
        else {
            return true
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : function that determines what happens when the user taps away from the textfield
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        confirmationCodeTextField.resignFirstResponder()
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
