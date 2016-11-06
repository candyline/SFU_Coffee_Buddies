//
//  ShakePage.swift
//  SFU Coffee Buddies
//
//  Created by Eton Kan on 2016-10-28.
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit

struct profile{
    var id = "581e99fd58b03c3c0831dd98"
    var meeting = "0"
    var gender = "0"
    var password = "0"
    var user = "0"
    var text = "0"
    var unknown = "0"
}

class ShakePage: UIViewController {
    
    @IBOutlet weak var shakephone: UILabel!
    @IBOutlet weak var placedinqueue: UILabel!
    @IBOutlet weak var currentlyinqueue: UILabel!
    let Serverhost = "http://127.0.0.1:8080/messages/"
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shakephone.isHidden = false
        placedinqueue.isHidden = true
        currentlyinqueue.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            shakephone.isHidden = true
            placedinqueue.isHidden = false
            let userprofile = profile()
            //let generalhost = URL(string: Serverhost)
            let appendUserUrl = Serverhost + userprofile.id
            let userhost = URL(string: appendUserUrl)
            //Reading from server
            //MainPage().readDataFromURL()
            //let linktohost = URL(generalhost)
            print("before read")
            //Does it even go in?
            let task = URLSession.shared.dataTask(with: userhost!) {data, response, error in
                guard error == nil else {
                    print ("I have an error") //error)
                    return
                }
                
                guard let data = data else {
                    print ("Data is empty")
                    return
                }
                //Why doesn't it work ?????????
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                print (json)
                print("IaminReadData")
                //let object = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //if let dictionary = object as? [String: AnyObject] {
                //    print(dictionary)
                //}
            }
            print("dataTask read  should be failed")
            
            task.resume()

            
            //Look for another user with meeting = one
            //If found, display the other user's information
            
            //else put user on the queue and let the other user look for you
            //Getting User's ID
            //Storing user able to meet on server data
            
            //let appendUserUrl = Serverhost + userprofile.id
            //let userhost = URL(string: appendUserUrl)
            //let appendUsertoHost = generalhost + userprofile.id as URL
            //let userHost = URL(fileURLWithPath: appendUsertoHost)

            let postData = NSMutableData(data: "meeting=1".data(using: String.Encoding.utf8)!)
            //postData.append("&user=M".data(using: String.Encoding.utf8)!)
            //MainPage().postDataToURL(postData: postData as Data)
            //Posting it to localhost:8080/messages/id
            let request = NSMutableURLRequest(url: userhost!,                                          cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            request.httpMethod = "POST"
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
