//
//  File Name: ShakePage.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Nov 11, 2016
//  List of Changes:
//  V1.0: Created by Daniel Tan
//  V1.1: default server address added
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 15, 2016
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
class ReportUser: UIViewController
{   
    
    @IBOutlet weak var whatsWrongLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var shakeAgainButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var reasonTextField: UITextView!
    
    var abuseMsg = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        whatsWrongLabel.isHidden = false
        thankYouLabel.isHidden = true
        reasonLabel.isHidden = false
        
        shakeAgainButton.isHidden = false
        submitButton.isHidden = false
        backButton.isHidden = true
        
        reasonTextField.isHidden = false
    }
    
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        reasonTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        abuseMsg = reasonTextField.text!
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
                "type"      : "", //new feature for lots of complains
                "message"   : self.abuseMsg
                ]
        print(parameters)
        
        Alamofire.request(serverabuse, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON
        {
                response in
                print(response)
        }
        submitButton.isHidden = true
        backButton.isHidden = true
        reasonLabel.isHidden = true
        reasonTextField.isHidden = true
        whatsWrongLabel.isHidden = true
        thankYouLabel.isHidden = false
        shakeAgainButton.isHidden = false
    }
    
    
}
