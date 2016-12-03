//  File Name: ShakePage.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Oct 28, 2016
//  
//  Changelog:
//  -File Created and Fundamental Functions Implemented
//  -motionEnded() detect user shaking motion
//  -labels are added
//  -Read and PUT to database are implemented
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
//
//  List of Bugs:
//  motionEnded(): 1) it will crash the database if zero entries are in it (Fixed - Eton Nov 11)
//                 2) types used for variables are not efficient (Fixed - Eton Nov 11)
//                 3) unable to block user due to server unable to return array in json (Fixed - Eton Dec 2)
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//Struct used to save user and target informations
var userprofile = Profile()
var targetprofile = Profile()

//Profile struct used to save user's or target user's information from database
//Author: Eton Kan
//Last Modifty: Dec 2,2016
//Known Bugs: none
struct Profile
{
    public
    var id = globalid
    var meeting = "0"
    var gender = "0"
    var pw = globalpw //User's password
    var username = "0"
    var bio = "0"
    var interest = "0"
    var email = globalemail
    var bus = "0"
    var major = "0"
    var blockedUser = [String]()
    var qrCode = "0"
    var image = "0"
    var coffee = 0
    var coffeeCode = "0"
}

//This classs is used to detect shake motion and communicate with user on the status placed on the queue
//Author: Eton Kan
//Last Modifty: Dec 2,2016
class ShakePage: UIViewController
{

    let yesMeeting = "true"
    //Declare all variables used in the storyboard
    @IBOutlet weak var shakePhone: UILabel!
    @IBOutlet weak var placedInQueue: UILabel!
    @IBOutlet weak var Disconnected: UILabel!
    @IBOutlet weak var profileMissing: UILabel!
    @IBOutlet weak var matched: UILabel!
    
    @IBOutlet weak var targetProfilePic: UIImageView!
    
    //Codes are unlinked (non solid circle) should be commented out due to graphic change
    //@IBOutlet weak var targetNameDisplay: UILabel!
    //@IBOutlet weak var targetGenderDisplay: UILabel!
    //@IBOutlet weak var targetBusDisplay: UILabel!
    //@IBOutlet weak var targetMajorDisplay: UILabel!
    //@IBOutlet weak var targetInterestDisplay: UILabel!
    //@IBOutlet weak var targetBioDisplay: UILabel!
    
    @IBOutlet weak var targetNameLabel: UILabel!
    @IBOutlet weak var targetGenderLabel: UILabel!
    @IBOutlet weak var targetBusLabel: UILabel!
    @IBOutlet weak var targetMajorLabel: UILabel!
    @IBOutlet weak var targetInterestLabel: UILabel!
    @IBOutlet weak var targetBioLabel: UILabel!

    @IBOutlet weak var letsChat: UIButton!
    @IBOutlet weak var nextOne: UIButton!
    @IBOutlet weak var busTogether: UIButton!
    @IBOutlet weak var reportAbuse: UIButton!
    
    //Initilize the page when user enter the page
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "shake iphone.png")!)
        
        //Instructing the user to shake their device
        shakePhone.isHidden = false
        placedInQueue.isHidden = true
        Disconnected.isHidden = true
        profileMissing.isHidden = true
        matched.isHidden = true
        
        //Hiding displays from user
        targetProfilePic.isHidden = true
        //targetNameDisplay.isHidden = true
        //targetGenderDisplay.isHidden = true
        //targetBusDisplay.isHidden = true
        //targetMajorDisplay.isHidden = true
        //targetInterestDisplay.isHidden = true
        //targetBioDisplay.isHidden = true
        
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
        reportAbuse.isHidden = true
        busTogether.isHidden = true
        
        //making circular profile pic image
        targetProfilePic.layer.cornerRadius = targetProfilePic.frame.size.width/2
        targetProfilePic.clipsToBounds = true
        
    }
    
    //Fill in all information in the struct profile
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func getDatafromServer(localProfile: inout Profile, dataBaseArray: JSON , index: Int)
    {
        //print(dataBaseArray)
        //print(index)
        //Enter the user's information into the Profile struct
        if let username  = dataBaseArray[index]["username"].string
        {
            localProfile.username = username
            //print(userprofile.username)
        }
        if let id = dataBaseArray[index]["_id"].string
        {
            localProfile.id = id
            //print(userprofile.id)
        }
        if let gender = dataBaseArray[index]["gender"].string
        {
            localProfile.gender = gender
            //print(userprofile.gender)
        }
        if let password = dataBaseArray[index]["pw"].string
        {
            localProfile.pw = password
            //print(userprofile.password)
        }
        if let bio = dataBaseArray[index]["bio"].string
        {
            localProfile.bio = bio
            //print(userprofile.text)
        }
        if let meeting = dataBaseArray[index]["meeting"].string
        {
            localProfile.meeting = meeting
            //print(userprofile.meeting)
        }
        if let interest = dataBaseArray[index]["interest"].string
        {
            localProfile.interest = interest
            //print(userprofile.meeting)
        }
        if let bus = dataBaseArray[index]["bus"].string
        {
            localProfile.bus = bus
            //print(userprofile.meeting)
        }
        if let major = dataBaseArray[index]["major"].string
        {
            localProfile.major = major
            //print(userprofile.meeting)
        }
        if let email = dataBaseArray[index]["email"].string
        {
            localProfile.email = email
            //print(userprofile.meeting)
        }
        if let qrcode = dataBaseArray[index]["QRcode"].string
        {
            localProfile.qrCode = qrcode
            //print(localProfile.qrcode)
        }
        if let image = dataBaseArray[index]["image"].string
        {
            localProfile.image = image
        }
        if let coffee = dataBaseArray[index]["coffee"].int
        {
            localProfile.coffee = coffee
        }
        if let coffeeCode = dataBaseArray[index]["coffeeCode"].string
        {
            localProfile.coffeeCode = coffeeCode
        }
        for users in 0 ... dataBaseArray[index]["blockUser"].count
        {
            if let blockUser = dataBaseArray[index]["blockUser"][users].string
            {
                if localProfile.blockedUser.count > 0
                {
                for userblocklist in 0 ... localProfile.blockedUser.count-1
                {
                    if blockUser != localProfile.blockedUser[userblocklist]
                    {
                        localProfile.blockedUser.append(blockUser)
                    }
                }
                }
                else
                {
                    localProfile.blockedUser.append(blockUser)
                }
            }
        }
    }
    
    //Blocking target email and update blockUser array on database
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func blockTarget(localProfile: Profile, blockingEmail: String, meeting: String)
    {
        var tempProfile = Profile()
        print("Blocking target user now")
        //Append targetUser's email on to user's blockUser array
        tempProfile.blockedUser = localProfile.blockedUser
        tempProfile.blockedUser.append(blockingEmail)
        let appendedUserUrl = serverprofile + userprofile.id
        // Store the information on the database
        let parameters: [String: Any] =
            [
                "meeting"   : meeting,
                "gender"    : localProfile.gender,
                "pw"        : localProfile.pw, // user's password
                "email"     : localProfile.email,
                "bio"       : localProfile.bio,
                "username"  : localProfile.username,
                "interest"  : localProfile.interest,
                "bus"       : localProfile.bus,
                "major"     : localProfile.major,
                "coffee"    : localProfile.coffee,
                "blockUser" : tempProfile.blockedUser,
                "QRcode"    : localProfile.qrCode,
                "image"     : localProfile.image,
                "coffeeCode": localProfile.coffee,
        ]
        //print(parameters)
        //Uploading updated user's information to database
        Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseString
         {
            response in
            print(response)
            print("blockTarget")
        }
    }
    
    //User didn't accpet the match, prompt user to shake again
    //Author: Eton Kan
    //Last Modify: Nov 20,2016
    //Known Bugs: none
    @IBAction func nextOne(_ sender: UIButton)
    {
        print("User say no :(")
        //Change the blocking of target and user so they will never see each other
        self.blockTarget(localProfile: userprofile, blockingEmail: targetprofile.email, meeting: userprofile.meeting)
        self.viewDidLoad()
    }
    
    //User accepted the match, remove target from queue and start chating
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func letChat(_ sender: UIButton)
    {
        //User accepted wants to chat with targetUser
        //Updating both user's blocking list to prevent repeated matching of the same user
        //Change target's meeting to false on DataBase
        self.blockTarget(localProfile: targetprofile, blockingEmail: userprofile.email, meeting: "false")
        //Change user's meeting to false on DataBase
        self.blockTarget(localProfile: userprofile, blockingEmail: targetprofile.email, meeting: "false")
        //Go to chat page
    }
    //A function that detects shake motion either match or put the current user on the queue
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: 1) it will crash the database if zero entries are in it (Fix - Eton Nov 11)
    //            2) types used for variables are not efficient(warnings) (Fix - Eton Nov 11)
    //            3) unable to block due to unable to get blockedUser list from database (Fix - Eton Dec 1)
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if event?.subtype == UIEventSubtype.motionShake
        {
            //Showing the user that shake is detected
            //Initialize Variabes
            var userFound = false
            var iscontinue = true
            
            //Getting user information from database
            Alamofire.request(serverprofile).responseJSON
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
                        if let email  = dataBaseArray[index]["email"].string
                        {
                            if email == userprofile.email
                            {
                                self.getDatafromServer(localProfile: &userprofile, dataBaseArray:   dataBaseArray, index : index)
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
                        if let target_email  = dataBaseArray[index]["email"].string
                        {
                            if let target_meeting = dataBaseArray[index]["meeting"].string
                            {
                                if target_email != userprofile.email && target_meeting == self.yesMeeting
                                {
                                    //Checking if the targeted email is blocked or not by the user
                                    if userprofile.blockedUser.count > 0
                                    {
                                        for blockedIndex in 0 ... userprofile.blockedUser.count-1
                                        {
                                            if target_email == userprofile.blockedUser[blockedIndex]
                                            {
                                                iscontinue = false
                                                break
                                            }
                                        }
                                    }
                                    if !iscontinue
                                    {
                                        continue
                                    }
                                    //Enter the target user's information into a profile struct
                                    self.getDatafromServer(localProfile: &targetprofile, dataBaseArray: dataBaseArray, index : index)
                                    //Display target user information on the ShakePage
                                    self.placedInQueue.isHidden = true
                                    self.matched.isHidden = false
                                    
                                    self.targetProfilePic.isHidden = false
                                    //self.targetNameDisplay.isHidden = false
                                    //self.targetGenderDisplay.isHidden = false
                                    //self.targetBusDisplay.isHidden = false
                                    //self.targetMajorDisplay.isHidden = false
                                    //self.targetInterestDisplay.isHidden = false
                                    //self.targetBioDisplay.isHidden = false
                                    
                                    self.targetNameLabel.isHidden = false
                                    self.targetGenderLabel.isHidden = false
                                    self.targetBusLabel.isHidden = false
                                    self.targetMajorLabel.isHidden = false
                                    self.targetInterestLabel.isHidden = false
                                    self.targetBioLabel.isHidden = false
                                    
                                    self.targetNameLabel.text = targetprofile.username
                                    self.targetGenderLabel.text = targetprofile.gender
                                    self.targetBusLabel.text = targetprofile.bus
                                    self.targetMajorLabel.text = targetprofile.major
                                    self.targetInterestLabel.text = targetprofile.interest
                                    self.targetBioLabel.text = targetprofile.bio
                                    if !(targetprofile.image.isEmpty  || targetprofile.image == "0")
                                    {
                                        self.targetProfilePic.image  = ProfileSetupViewController().stringToImage(userString: targetprofile.image)
                                    }
                                    
                                    //Let user decide if target user catch their interest
                                    self.letsChat.isHidden = false
                                    self.nextOne.isHidden = false
                                    self.reportAbuse.isHidden = false
                                    self.busTogether.isHidden = false
                                    return
                                }
                            }
                        }
                    }
                    print("NO Match Found")
                    print("Putting User ON Queue")
                    //Change user's meeting to true on DataBase and let the other users look for you
                    let appendedUserUrl = serverprofile + userprofile.id
                    // Store the information on the DB
                    let parameters: [String: Any] =
                        [
                            "meeting"   : self.yesMeeting,
                            "gender"    : userprofile.gender,
                            "pw"        : userprofile.pw, // user's password
                            "email"     : userprofile.email,
                            "bio"       : userprofile.bio,
                            "username"  : userprofile.username,
                            "interest"  : userprofile.interest,
                            "bus"       : userprofile.bus,
                            "major"     : userprofile.major,
                            "coffee"    : userprofile.coffee,
                            "blockUser" : userprofile.blockedUser,
                            "QRcode"    : userprofile.qrCode,
                            "image"     : userprofile.image,
                            "coffeeCode": userprofile.coffeeCode
                        ]
                    //print(parameters)
                    //Updating user status of meeting to yes
                    Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                        .responseString
                        { response in
                            print(response)
                            return
                        }
            }
        }
    }
}
