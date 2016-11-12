//
//  File Name: ShakePage.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Oct 28, 2016
//  List of Changes:
//  V1.0: Created by Eton Kan
//  V1.1: motionEnded() detect user shaking motion
//  V1.2: labels are added
//  V1.3: Read and PUT to database are implemented
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 11, 2016
//
//  List of Bugs:
//  motionEnded(): 1) it will crash the database if zero entries are in it (Fix - Eton Nov 11)
//                 2) types used for variables are not efficient (Fix - Eton Nov 11)
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


//public struct that is used to save information from database
//Author: Eton Kan
//Last Modifty: Nov 11,2016
//Known Bugs: none
struct Profile
{
    public
    var id = "0"
    var meeting = "0"
    var gender = "0"
    var pw = "0" //User's password
    var username = "0"
    var bio = "0"
    var interest = "0"
    var email = "0"
    var bus = "0"
    var major = "0"
    
}

//This classs is used to detect shake motion and communicate with user on the status
//placed on the queue
//Author: Eton Kan
//Last Modifty: Nov 11,2016
class ShakePage: UIViewController
{
    //Struct used to save user and target informations
    var userProfile = Profile()
    var targetProfile = Profile()
    //Declare all variables used in the storyboard
    @IBOutlet weak var shakePhone: UILabel!
    @IBOutlet weak var placedInQueue: UILabel!
    @IBOutlet weak var Disconnected: UILabel!
    @IBOutlet weak var profileMissing: UILabel!
    @IBOutlet weak var matched: UILabel!
    
    @IBOutlet weak var targetProfilePic: UIImageView!
    @IBOutlet weak var targetNameDisplay: UILabel!
    @IBOutlet weak var targetGenderDisplay: UILabel!
    @IBOutlet weak var targetBusDisplay: UILabel!
    @IBOutlet weak var targetMajorDisplay: UILabel!
    @IBOutlet weak var targetInterestDisplay: UILabel!
    @IBOutlet weak var targetBioDisplay: UILabel!
    
    @IBOutlet weak var targetNameLabel: UILabel!
    @IBOutlet weak var targetGenderLabel: UILabel!
    @IBOutlet weak var targetBusLabel: UILabel!
    @IBOutlet weak var targetMajorLabel: UILabel!
    @IBOutlet weak var targetInterestLabel: UILabel!
    @IBOutlet weak var targetBioLabel: UILabel!

    @IBOutlet weak var letsChat: UIButton!
    @IBOutlet weak var nextOne: UIButton!
    //Initilize the page when user enter the page
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Instructing the user to shake their device
        shakePhone.isHidden = false
        placedInQueue.isHidden = true
        Disconnected.isHidden = true
        profileMissing.isHidden = true
        matched.isHidden = true
        
        //Hiding displays from user
        targetProfilePic.isHidden = true
        targetNameDisplay.isHidden = true
        targetGenderDisplay.isHidden = true
        targetBusDisplay.isHidden = true
        targetMajorDisplay.isHidden = true
        targetInterestDisplay.isHidden = true
        targetBioDisplay.isHidden = true
        
        //Hiding labels from user
        targetNameLabel.isHidden = true
        targetGenderLabel.isHidden = true
        targetBusLabel.isHidden = true
        targetMajorLabel.isHidden = true
        targetInterestLabel.isHidden = true
        targetBioLabel.isHidden = true
        
        //Hiding buttons from user
        letsChat.isHidden = true
        nextOne.isHidden = true
    }
    
    //Fill in all information in the struct profile
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: none
    func getDatafromServer(userProfile: inout Profile, dataBaseArray: JSON , index: Int)
    {
        //Enter the user's information into the Profile struct
        if let username  = dataBaseArray[index]["username"].string
        {
            userProfile.username = username
            //print(userProfile.username)
        }
        if let id = dataBaseArray[index]["_id"].string
        {
            userProfile.id = id
            //print(userProfile.id)
        }
        if let gender = dataBaseArray[index]["gender"].string
        {
            userProfile.gender = gender
            //print(userProfile.gender)
        }
        if let password = dataBaseArray[index]["pw"].string
        {
            userProfile.pw = password
            //print(userProfile.password)
        }
        if let bio = dataBaseArray[index]["bio"].string
        {
            userProfile.bio = bio
            //print(userProfile.text)
        }
        if let meeting = dataBaseArray[index]["meeting"].string
        {
            userProfile.meeting = meeting
            //print(userProfile.meeting)
        }
        if let interest = dataBaseArray[index]["interest"].string
        {
            userProfile.interest = interest
            //print(userProfile.meeting)
        }
        if let bus = dataBaseArray[index]["bus"].string
        {
            userProfile.bus = bus
            //print(userProfile.meeting)
        }
        if let major = dataBaseArray[index]["major"].string
        {
            userProfile.major = major
            //print(userProfile.meeting)
        }
        if let email = dataBaseArray[index]["email"].string
        {
            userProfile.email = email
            //print(userProfile.meeting)
        }
    }
    //User didn't accpet the match, prompt user to shake again
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: none
    @IBAction func nextOne(_ sender: UIButton)
    {
        print("User say no :(")
        self.shakePhone.isHidden = false
        self.placedInQueue.isHidden = true
        self.matched.isHidden = true
        
        self.targetProfilePic.isHidden = true
        self.targetNameDisplay.isHidden = true
        self.targetGenderDisplay.isHidden = true
        self.targetBusDisplay.isHidden = true
        self.targetMajorDisplay.isHidden = true
        self.targetInterestDisplay.isHidden = true
        self.targetBioDisplay.isHidden = true
        
        self.targetNameLabel.isHidden = true
        self.targetGenderLabel.isHidden = true
        self.targetBusLabel.isHidden = true
        self.targetMajorLabel.isHidden = true
        self.targetInterestLabel.isHidden = true
        self.targetBioLabel.isHidden = true
        
        self.letsChat.isHidden = true
        self.nextOne.isHidden = true

    }
    
    //User accepted the match, remove target from queue and start chating
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: none
    @IBAction func letChat(_ sender: UIButton)
    {
        //Updateing Target meeting information
        //.put change targetProfile.meeting to false
        //Change user's meeting to true on DataBase and let the other users look for you
        let appendedUserUrl = serverhost + self.targetProfile.id
        // Store the information on the DB
        let parameters: [String: Any] =
            [
                "meeting"  : "false",
                "gender"   : self.targetProfile.gender,
                "pw"       : self.targetProfile.pw, // user's password
                "email"    : self.targetProfile.email,
                "bio"      : self.targetProfile.bio,
                "username" : self.targetProfile.username,
                "interest" : self.targetProfile.interest,
                "bus"      : self.targetProfile.bus,
                "major"    : self.targetProfile.major
                
        ]
        print(parameters)
        Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseString
            { response in
                print(response)
            }
        //Go to chat page
    }
    //A function that detects shake motion either match or put the current user on the queue
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: 1) it will crash the database if zero entries are in it (Fix - Eton Nov 11)
    //            2) types used for variables are not efficient(warnings) (Fix - Eton Nov 11)
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            //Showing the user that shake is detected
            //Initialize Variabes
            //var userProfile = Profile()
            //var targetProfile = Profile()
            let yesMeeting = "true"
            //If user with the username is find in the data base
            var userFound = false
            userProfile.username = globalname
            //Getting user information from database
            Alamofire.request(serverhost).responseJSON
                {
                response in
                //Testing if data available for grab
                    switch response.result
                    {
                    case .success:
                        print("Data Found")
                    case .failure(let error):
                        print(error)
                        print("Cannot get data from server")
                        self.Disconnected.isHidden = false
                        return
                    }
                    
                    //Parsing the data taken from server
                    let dataBaseArray = JSON(response.result.value!)
                
                    //Search the user inside the JSON
                    for index in 0 ... dataBaseArray.count
                    {
                        if let username  = dataBaseArray[index]["username"].string
                        {
                            if username == self.userProfile.username
                            {
                                self.getDatafromServer(userProfile: &self.userProfile, dataBaseArray:   dataBaseArray, index : index)
                                userFound = true
                                self.profileMissing.isHidden = true
                                break
                            }
                        }
                    }
                    //Checking if user have enetered their profile informations
                    if !userFound
                    {
                        print("User NOT Found")
                        print("Please create User Profile first")
                        self.profileMissing.isHidden = false
                        self.shakePhone.isHidden = false
                        return
                    }
                    self.shakePhone.isHidden = true
                    print("User Found")
                    self.placedInQueue.isHidden = false
                    //Look for other users who want to meet
                    //If found, display the other user's information for current user
                    for index in 0 ... dataBaseArray.count
                    {
                        //Looking for user that is able to meet
                        if let target_user  = dataBaseArray[index]["username"].string
                        {
                            if let target_meeting = dataBaseArray[index]["meeting"].string
                            {
                                if target_user != self.userProfile.username && target_meeting == yesMeeting{
                                    //Enter the target user's information into a profile struct
                                    self.getDatafromServer(userProfile: &self.targetProfile, dataBaseArray: dataBaseArray, index : index)
                                    //Display target user information on the ShakePage
                                    self.placedInQueue.isHidden = true
                                    self.matched.isHidden = false
                                    
                                    self.targetProfilePic.isHidden = false
                                    self.targetNameDisplay.isHidden = false
                                    self.targetGenderDisplay.isHidden = false
                                    self.targetBusDisplay.isHidden = false
                                    self.targetMajorDisplay.isHidden = false
                                    self.targetInterestDisplay.isHidden = false
                                    self.targetBioDisplay.isHidden = false
                                
                                    self.targetNameLabel.isHidden = false
                                    self.targetGenderLabel.isHidden = false
                                    self.targetBusLabel.isHidden = false
                                    self.targetMajorLabel.isHidden = false
                                    self.targetInterestLabel.isHidden = false
                                    self.targetBioLabel.isHidden = false
                                
                                    self.targetNameLabel.text = self.targetProfile.username
                                    self.targetGenderLabel.text = self.targetProfile.gender
                                    self.targetBusLabel.text = self.targetProfile.bus
                                    self.targetMajorLabel.text = self.targetProfile.major
                                    self.targetInterestLabel.text = self.targetProfile.interest
                                    self.targetBioLabel.text = self.targetProfile.bio
                                
                                    self.letsChat.isHidden = false
                                    self.nextOne.isHidden = false

                                    return
                                }
                            }
                        }
                    }
                    print("NO Match Found")
                    print("Putting User ON Queue")
                    //Change user's meeting to true on DataBase and let the other users look for you
                    let appendedUserUrl = serverhost + self.userProfile.id
                    // Store the information on the DB
                    let parameters: [String: Any] =
                        [
                            "meeting"  : "true",
                            "gender"   : self.userProfile.gender,
                            "pw"       : self.userProfile.pw, // user's password
                            "email"    : self.userProfile.email,
                            "bio"      : self.userProfile.bio,
                            "username" : self.userProfile.username,
                            "interest" : self.userProfile.interest,
                            "bus"      : self.userProfile.bus,
                            "major"    : self.userProfile.major
                        
                        ]
                    print(parameters)
                    Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                        .responseString
                        { response in
                            print(response)
                        }
            }
        }
    }
}
