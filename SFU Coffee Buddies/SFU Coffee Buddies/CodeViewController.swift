//
//  CodeViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController, UITextFieldDelegate {

    var code = ""
    
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationCodeTextField.delegate = self
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(CodeViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        code = confirmationCodeTextField.text!
    }

    @IBAction func submitCodePressed(_ sender: UIButton) {
        // somehow validate the code which will lead to the profile setup
    }
    
    
    // go to the next page (profile page setup) after confirming if the user entered the correct code
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "submitCode")
        {
            // if (codeIsCorrect)
            //    return true
            // else
            //    return false
            return true
            
        }
        else {
            return true
        }
    }
    
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
