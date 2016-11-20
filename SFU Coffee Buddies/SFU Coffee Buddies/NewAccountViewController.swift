//
//  NewAccountViewController.swift
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
//      - Email sending and code generation doesn't work - November 6

import UIKit
import Alamofire
import SwiftyJSON

var globalemail : String = ""
var globalpw : String = ""
var globalid : String = ""
//var globalcode : String = ""

class NewAccountViewController: UIViewController, UITextFieldDelegate
{

    // Outlets and Variables
    var email = ""
    var pw = ""
    @IBOutlet weak var incorrectEmailLabel: UITextView!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Assign delegates
        emailTextField.delegate = self
        pwTextField.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(NewAccountViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        // Hide the warning label
        incorrectEmailLabel.isHidden = true
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Creator : Daniel Tan
    // Purpose : Implementing the optional functions to handle what the textField does, it resigns the first responder thus hide keyboard
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }*/
    
    // Creator : Daniel Tan
    // Purpose : Implementing the optional functions to handle what the textField does when it ends editting
    //           read which text field and stores the text from that field into the corresponding variable
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField == emailTextField)
        {
            email = emailTextField.text!
            globalemail = email
        }
        else
        {
            pw = pwTextField.text!
            globalpw = pw
        }
    }
    
    // Creator : Eton Kan
    // Purpose : Go to the next view controller after checking for valid emails
    // Last Modified Author: Eton Kan
    // Last Modified Date: Nov 20, 2016
    @IBAction func signUp(_ sender: UIButton)
    {
        if (email.hasSuffix("@sfu.ca"))
        {
            //sendEmail()
            
            //Storing email and password to database (server)
            let parameters: [String: Any] =
                [
                    "meeting"  : "false",
                    "pw"       : globalpw, // user's password
                    "email"    : globalemail
            ]
            print(parameters)
            //Creating a new profile in the database
            Alamofire.request(serverprofile, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print("Successfully created a new profile")
                        print("Changing to Profile Setup View Controller")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSetup")
                        self.present(vc!, animated:true, completion: nil)
                    case .failure (let error):
                        print(error)
                        print("Cannot Post to database")
                    }
            }
        }
    }

    
    // Creator : Daniel Tan
    // Purpose : function that determines what happens when the user taps away from the textfield
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        emailTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
    }

    // Purpose : Sends an email to the user to verify the authenticity of the SFU email
    //           Doesn't work currently
    /*
    func sendEmail() {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.mailgun.net/v3/sandbox41849eb2be4f4d379370e7bddb90820f.mailgun.org/messages/")! as URL)
        request.httpMethod = "POST"
        let data = "from: SFU Coffee Buddies <aa493c2a596cc4cd26c5fa6172aa7523>&to: [daniel_tzj@hotmail.com,(Personal info)]&subject:Hello&text:Testinggsome Mailgun awesomness!"
        request.httpBody = data.data(using: String.Encoding.ascii)
        request.setValue("key-552a5e53b123297db8fd30749e26cefb", forHTTPHeaderField: "api")
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if let error = error {
                print(error)
            }
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
            }
            
            
        })
        task.resume()
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
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
