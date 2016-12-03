//
//  File Name: ReportUser.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Nov 11, 2016
//  List of Changes:
//  V1.0: Created by Eton Kan
//  V1.1: Posting Abuse now work
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 20, 2016
//
//  List of Bugs: none
//
//  Copyright © 2016 Eton Kan. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//This classs is the main manual of the app
//Author: Eton Kan
//Creation Date: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 16,2016
class ReportUser: UIViewController, UITextViewDelegate, UINavigationControllerDelegate
{   
    
    @IBOutlet weak var whatsWrongLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    //@IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var returnToMainPage: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var reasonTextField: UITextView!
    
    var abuseMsg: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        whatsWrongLabel.isHidden = false
        thankYouLabel.isHidden = true
        //reasonLabel.isHidden = false
        
        returnToMainPage.isHidden = true
        submitButton.isHidden = false
        //backButton.isHidden = false
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        
        reasonTextField.isHidden = false
        reasonTextField.layer.cornerRadius = 8.0
        reasonTextField.layer.borderColor = UIColor.black.cgColor
        reasonTextField.layer.borderWidth = 0.8
        
        reasonTextField.delegate = self
        
        // Tap Gesture will close the keyboard, when tapping the view, will call the tappedAwayFunction
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(ReportUser.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
        
        // Adds Observer for the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        reasonTextField.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textField: UITextView)
    {
        self.abuseMsg = reasonTextField.text
    }
    
    @IBAction func toMainPage(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        self.present(vc, animated:true, completion: nil)
    }
    
    @IBAction func submitAbuse(_ sender: UIButton)
    {
        print("Begin .POST to database")
        
        //let message = reasonTextField
        //Storing user abuse complain to database
        let parameters: [String: Any] =
            [
                "fromUser"  : userProfile.username,
                "fromEmail" : userProfile.email,
                "toUser"    : targetProfile.username,
                "toEmail"   : targetProfile.email,
                "message"   : self.abuseMsg
                ]
        print(parameters)
        
        Alamofire.request(serverabuse, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString
        {
                response in
                print(response)
                ShakePage().blockTarget(localProfile: targetProfile, blockingEmail: userProfile.email, meeting: targetProfile.meeting)
                ShakePage().blockTarget(localProfile: userProfile, blockingEmail: targetProfile.email, meeting: userProfile.meeting)
            print("Target email should be blocked (submitAbuse)")
        }
        submitButton.isHidden = true
        //backButton.isHidden = true
        //reasonLabel.isHidden = true
        reasonTextField.isHidden = true
        whatsWrongLabel.isHidden = true
        thankYouLabel.isHidden = false
        returnToMainPage.isHidden = false
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
