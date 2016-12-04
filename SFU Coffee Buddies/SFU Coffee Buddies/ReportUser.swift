//  File Name: ReportUser.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Nov 11, 2016
//  List of Changes:
//  V1.0: Created by Eton Kan
//  V1.1: Posting Abuse to database
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
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
    @IBOutlet weak var errorSavingMsg: UILabel!
    
    @IBOutlet weak var returnToMainPage: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var reasonTextField: UITextView!
    
    var abuseMsg: String = ""
    
    //Initilize the page when user enter the page
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Prompting user to tell what is wrong with target user
        whatsWrongLabel.isHidden = false
        thankYouLabel.isHidden = true
        errorSavingMsg.isHidden = true
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
    
    //Detecting if user taped somewhere else
    //Author: Daniel Tan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        reasonTextField.resignFirstResponder()
    }
    
    //Saving report abuse text
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func textViewDidEndEditing(_ textField: UITextView)
    {
        self.abuseMsg = reasonTextField.text
    }
    
    //Return to main page after reporting user
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func toMainPage(_ sender: UIButton)
    {
        MainPage().resetProfile(localProfile: &targetprofile)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        self.present(vc, animated:true, completion: nil)
    }
    
    //Uploading report abuse text from user to database
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func submitAbuse(_ sender: UIButton)
    {
        self.abuseMsg = reasonTextField.text
        if !(self.abuseMsg == "" || targetprofile.email == "" || targetprofile.username == "" || userprofile.email == "" || userprofile.username == "")
        {
            print("Begin .POST to database")
        
            //Storing user abuse complain to database
            let parameters: [String: Any] =
                [
                    "fromUser"  : userprofile.username,
                    "fromEmail" : userprofile.email,
                    "toUser"    : targetprofile.username,
                    "toEmail"   : targetprofile.email,
                    "message"   : self.abuseMsg
                ]
            //print(parameters)
            //Uploading user text message to database
            Alamofire.request(serverabuse, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString
            {
                response in
                print(response)
                //Blocking each other so they will not see each other again
                ShakePage().blockTarget(localProfile: targetprofile, blockingEmail: userprofile.email, meeting: targetprofile.meeting)
                ShakePage().blockTarget(localProfile:   userprofile, blockingEmail: targetprofile.email, meeting: userprofile.meeting)
                print("Target email blocked (submitAbuse)")
            }
            submitButton.isHidden = true
            //backButton.isHidden = true
            //reasonLabel.isHidden = true
            reasonTextField.isHidden = true
            whatsWrongLabel.isHidden = true
            thankYouLabel.isHidden = false
            errorSavingMsg.isHidden = true
            returnToMainPage.isHidden = false
        }
        else
        {
            errorSavingMsg.isHidden = false
        }
    }
    
    // Creator : Daniel Tan
    // Purpose : When the keyboard pops up, the view will move up so the user can see the text view it is blocking
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
        
    }
    
    // Creator : Daniel Tan
    // Purpose : When the keyboard is retracted, will move the view back to the original position
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        }
    }
}
