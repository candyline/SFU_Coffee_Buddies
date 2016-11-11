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
//  Last Modified Date: Nov 6, 2016
//
//  List of Bugs:
//  motionEnded(): 1) it will crash the database if zero entries are in it
//                 2) types used for variables are not efficient
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//public struct that is used to save information from database
//Author: Eton Kan
//Last Modifty: Nov 6,2016
//Known Bugs: none
struct Profile{
    public
    var id = "0"
    var meeting = "0"
    var gender = "0"
    var password = "0"
    var user = "0"
    var text = "0"
    var unknown = "0"
}

//This classs is used to detect shake motion and communicate with user on the status
//placed on the queue
//Author: Eton Kan
//Last Modifty: Nov 6,2016
class ShakePage: UIViewController {
    
    //Declare all variables used in the storyboard
    @IBOutlet weak var targetBioLabel: UILabel!
    @IBOutlet weak var targetGenderLabel: UILabel!
    @IBOutlet weak var targetNameLabel: UILabel!
    @IBOutlet weak var targetBioDisplay: UILabel!
    @IBOutlet weak var targetGenderDisplay: UILabel!
    @IBOutlet weak var shakePhone: UILabel!
    @IBOutlet weak var placedInQueue: UILabel!
    @IBOutlet weak var matched: UILabel!
    @IBOutlet weak var targetNameDisplay: UILabel!
    //Default Server Address (localhost)
    //let Serverhost = "http://127.0.0.1:8080/messages/"
   
    //Initilize the page when user enter the page
    //Author: Eton Kan
    //Last Modify: Nov 6,2016
    //Known Bugs: none
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instructing the user to shake their device
        shakePhone.isHidden = false
        //Hiding the labels from the user
        placedInQueue.isHidden = true
        matched.isHidden = true
        targetNameDisplay.isHidden = true
        targetGenderDisplay.isHidden = true
        targetBioDisplay.isHidden = true
        targetBioLabel.isHidden = true
        targetNameLabel.isHidden = true
        targetGenderLabel.isHidden = true
    }

    //A function that detects shake motion either match or put the current user on the queue
    //Author: Eton Kan
    //Last Modify: Nov 6,2016
    //Known Bugs: 1) it will crash the database if zero entries are in it
    //            2) types used for variables are not efficient
    //Possible improvements: .PUT should be in a separate function
    //                       .READ should be in a separate function
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            //Showing the user that shake is detected
            shakePhone.isHidden = true
            placedInQueue.isHidden = false
            //Initialize Variabes
            var userProfile = Profile()
            var targetProfile = Profile()
            let yesMeeting = "true"
            userProfile.user = globalname
            var error = "1"
            //Getting user information from database
            Alamofire.request(serverhost).responseJSON {
                response in
                //Used for testing outputs
                //print(response.request)  // original URL request
                //print(response.response) // HTTP URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                let dataBaseArray = JSON(response.result.value!)
                
                //Search the user inside the testing array
                for index in 0 ... dataBaseArray.count {
                    if let user  = dataBaseArray[index]["user"].string{
                        if user == userProfile.user{
                            //Enter the user's information into the Profile struct
                            if let id = dataBaseArray[index]["_id"].string{
                                userProfile.id = id
                                //print(userProfile.id)
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
                }
                if error == "1"{
                    print("User NOT Found")
                    print("Please create User Profile first")
                    return
                }
                
                //Look for other users who want to meet
                //If found, display the other user's information for current user
                for index in 0 ... dataBaseArray.count {
                    //Looking for user that is able to meet
                    if let target_user  = dataBaseArray[index]["user"].string{
                        if let target_meeting = dataBaseArray[index]["meeting"].string{
                            if target_user != userProfile.user && target_meeting == yesMeeting{
                                //Enter the target user's information into a profile struct
                                if let id = dataBaseArray[index]["_id"].string{
                                    targetProfile.id = id
                                    //print(targetProfile.id)
                                }
                                if let gender = dataBaseArray[index]["gender"].string{
                                    targetProfile.gender = gender
                                    //print(targetProfile.gender)
                                }
                                if let password = dataBaseArray[index]["password"].string{
                                    targetProfile.password = password
                                    //print(targetProfile.password)
                                }
                                if let text = dataBaseArray[index]["text"].string{
                                    targetProfile.text = text
                                    //print(targetProfile.text)
                                }
                                if let meeting = dataBaseArray[index]["meeting"].string{
                                    targetProfile.meeting = meeting
                                    //print(targetProfile.meeting)
                                }
                                if let userName = dataBaseArray[index]["user"].string{
                                    targetProfile.user = userName
                                    //print(targetProfile.user)
                                }
                                
                                //Display target user information on the ShakePage
                                self.placedInQueue.isHidden = true
                                self.matched.isHidden = false
                                self.targetNameDisplay.isHidden = false
                                self.targetGenderDisplay.isHidden = false
                                self.targetBioDisplay.isHidden = false
                                self.targetBioLabel.isHidden = false
                                self.targetNameLabel.isHidden = false
                                self.targetGenderLabel.isHidden = false
                                self.targetNameLabel.text = targetProfile.user
                                self.targetGenderLabel.text = targetProfile.gender
                                self.targetBioLabel.text = targetProfile.text
                                
                                //Updateing Target meeting information
                                //.put change targetProfile.meeting to false
                                let headers = [
                                    "content-type": "application/x-www-form-urlencoded",
                                    "authorization": "Basic Og==",
                                    "cache-control": "no-cache",
                                    "postman-token": "6f01f645-96bb-f323-a5db-4abe6ba03694"
                                ]
                                
                                let appendedUserUrl = serverhost + targetProfile.id
                                let userUrl = NSURL(string: appendedUserUrl)
                                let userUser = "&user="+targetProfile.user
                                //print(userUser)
                                let userPass = "&password="+targetProfile.password
                                //print(userPass)
                                let userGender = "&gender="+targetProfile.gender
                                //print(userGender)
                                let userText = "&text="+targetProfile.text
                                //print(userText)
                                //Modifying the target user meeting variable to false
                                var postData = NSMutableData(data: "meeting=false".data(using: String.Encoding.utf8)!)
                                postData.append(userUser.data(using: String.Encoding.utf8)!)
                                postData.append(userPass.data(using: String.Encoding.utf8)!)
                                postData.append(userGender.data(using: String.Encoding.utf8)!)
                                postData.append(userText.data(using: String.Encoding.utf8)!)
                                
                                var request = NSMutableURLRequest(url: userUrl! as URL,
                                                                  cachePolicy: .useProtocolCachePolicy,
                                                                  timeoutInterval: 10.0)
                                request.httpMethod = "PUT"
                                request.allHTTPHeaderFields = headers
                                request.httpBody = postData as Data
                                //Sending request using http method
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
                                
                                return
                            }
                        }
                    }
                }
                print("NO Match Found")
                print("Putting User ON Queue")
                //Change user's meeting to true on DataBase and let the other users look for you
                let headers = [
                    "content-type": "application/x-www-form-urlencoded",
                    "authorization": "Basic Og==",
                    "cache-control": "no-cache",
                    "postman-token": "6f01f645-96bb-f323-a5db-4abe6ba03694"
                ]
                print(userProfile.id)
                let appendedUserUrl = serverhost + userProfile.id
                let userUrl = NSURL(string: appendedUserUrl)
                let userUser = "&user="+userProfile.user
                print(userUser)
                let userPass = "&password="+userProfile.password
                print(userPass)
                let userGender = "&gender="+userProfile.gender
                print(userGender)
                let userText = "&text="+userProfile.text
                print(userText)
                //Sending the information of the user to Database
                var postData = NSMutableData(data: "meeting=true".data(using: String.Encoding.utf8)!)
                postData.append(userUser.data(using: String.Encoding.utf8)!)
                postData.append(userPass.data(using: String.Encoding.utf8)!)
                postData.append(userGender.data(using: String.Encoding.utf8)!)
                postData.append(userText.data(using: String.Encoding.utf8)!)
                
                var request = NSMutableURLRequest(url: userUrl! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data
                //Sending request using http method
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
