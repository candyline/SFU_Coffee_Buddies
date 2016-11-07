//
//  ShakePage.swift
//  SFU Coffee Buddies
//
//  Created by Eton Kan on 2016-10-28.
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


struct profile{
    public
    var id = "0"
    var meeting = "0"
    var gender = "0"
    var password = "0"
    var user = "0"
    var text = "0"
    var unknown = "0"
}

class ShakePage: UIViewController {
    
    //Declare all the variables used in the storyboard
    @IBOutlet weak var TargetBioLabel: UILabel!
    @IBOutlet weak var TargetGenderLabel: UILabel!
    @IBOutlet weak var TargetNameLabel: UILabel!
    @IBOutlet weak var TargetBioDisplay: UILabel!
    @IBOutlet weak var TargetGenderDisplay: UILabel!
    @IBOutlet weak var shakephone: UILabel!
    @IBOutlet weak var placedinqueue: UILabel!
    @IBOutlet weak var currentlyinqueue: UILabel!
    @IBOutlet weak var matched: UILabel!
    @IBOutlet weak var TargetNameDisplay: UILabel!
    //Default Server Address
    let Serverhost = "http://127.0.0.1:8080/messages/"
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shakephone.isHidden = false
        placedinqueue.isHidden = true
        currentlyinqueue.isHidden = true
        matched.isHidden = true
        TargetNameDisplay.isHidden = true
        TargetGenderDisplay.isHidden = true
        TargetBioDisplay.isHidden = true
        TargetBioLabel.isHidden = true
        TargetNameLabel.isHidden = true
        TargetGenderLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //A function that detects shake motion either match or put the current user on the queue
    //Author: Eton Kan
    //Last Modify: Nov 6,2016
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            shakephone.isHidden = true
            placedinqueue.isHidden = false
            var userProfile = profile()
            var targetProfile = profile()
            let yesMeeting = "true"
            userProfile.user = globalname
            var error = "1"
            //Getting information from user
            Alamofire.request(Serverhost).responseJSON {
               response in
                    //print(response.request)  // original URL request
                    //print(response.response) // HTTP URL response
                    //print(response.data)     // server data
                    //print(response.result)   // result of response serialization
                
                    let dataBaseArray = JSON(response.result.value!)
                //Search the user inside the testing array
                for index in 0 ... dataBaseArray.count {
                    if let user  = dataBaseArray[index]["user"].string{
                        if user == userProfile.user{
                            //Enter the user's information into a profile struct
                            if let id = dataBaseArray[index]["_id"].string{
                                userProfile.id = id
                                print(userProfile.id)
                            }
                            if let gender = dataBaseArray[index]["gender"].string{
                                userProfile.gender = gender
                                //print(userProfile.gender)
                            }
                            if let password = dataBaseArray[index]["password"].string{
                                userProfile.password = password
                                //print(userProfile.password)
                            }
                            if let text = dataBaseArray[index]["text"].string{
                                userProfile.text = text
                                //print(userProfile.text)
                            }
                            if let meeting = dataBaseArray[index]["meeting"].string{
                                userProfile.meeting = meeting
                                error = "0"
                                //print(userProfile.meeting)
                            }
                            break;
                        }
                    }
                    //error = "0"
                }
                if error == "1"{
                    print("User NOT Found")
                    print("Please create User Profile first")
                    return
                    }
            
                //Look for another user who want to meet
                //If found, display the other user's information
                for index in 0 ... dataBaseArray.count {
                    if let target_user  = dataBaseArray[index]["user"].string{
                        if let target_meeting = dataBaseArray[index]["meeting"].string{
                            if target_user != userProfile.user && target_meeting == yesMeeting{
                                //Enter the target user's information into a profile struct
                                if let id = dataBaseArray[index]["_id"].string{
                                    targetProfile.id = id
                                    print(targetProfile.id)
                                }
                                if let gender = dataBaseArray[index]["gender"].string{
                                    targetProfile.gender = gender
                                    print(targetProfile.gender)
                                }
                                if let userName = dataBaseArray[index]["user"].string{
                                    targetProfile.user = userName
                                    print(targetProfile.user)
                                }
                                if let password = dataBaseArray[index]["password"].string{
                                    targetProfile.password = password
                                    print(targetProfile.password)
                                }
                                if let text = dataBaseArray[index]["text"].string{
                                    targetProfile.text = text
                                    print(targetProfile.text)
                                }
                                if let meeting = dataBaseArray[index]["meeting"].string{
                                    targetProfile.meeting = meeting
                                    print(targetProfile.meeting)
                                }
                                //.put change targetProfile.meeting to false
                                
                                //Go to the profile screen and display target user information
                                self.placedinqueue.isHidden = true
                                self.matched.isHidden = false
                                self.TargetNameDisplay.isHidden = false
                                self.TargetGenderDisplay.isHidden = false
                                self.TargetBioDisplay.isHidden = false
                                self.TargetBioLabel.isHidden = false
                                self.TargetNameLabel.isHidden = false
                                self.TargetGenderLabel.isHidden = false
                                self.TargetNameLabel.text = targetProfile.user
                                self.TargetGenderLabel.text = targetProfile.gender
                                self.TargetBioLabel.text = targetProfile.text
                                return
                            }
                        }
                    }
                }
            print("NO Match Found")
            print("Putting User ON Queue")
            //Change meeting to true on DataBase and let the other user look for you
            let headers = [
                    "content-type": "application/x-www-form-urlencoded",
                    "authorization": "Basic Og==",
                    "cache-control": "no-cache",
                    "postman-token": "6f01f645-96bb-f323-a5db-4abe6ba03694"
            ]
            print(userProfile.id)
            let appendedUserUrl = self.Serverhost + userProfile.id
            let userUrl = NSURL(string: appendedUserUrl)
            let userText = "text="+userProfile.text
                print(userText)
            let userUser = "&user="+userProfile.user
                print(userUser)
            //Sending the information of the user to Database
            var postData = NSMutableData(data: "text=SFU".data(using: String.Encoding.utf8)!)
            postData.append(userUser.data(using: String.Encoding.utf8)!)
            postData.append("&password=789".data(using: String.Encoding.utf8)!)
            postData.append("&gender=male".data(using: String.Encoding.utf8)!)
            postData.append("&meeting=true".data(using: String.Encoding.utf8)!)
            
            var request = NSMutableURLRequest(url: userUrl! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
            })
            
            dataTask.resume()
        }
    }
    
}
}
