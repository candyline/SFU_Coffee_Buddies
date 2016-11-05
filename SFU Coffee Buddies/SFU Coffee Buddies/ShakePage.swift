//
//  ShakePage.swift
//  SFU Coffee Buddies
//
//  Created by Eton Kan on 2016-10-28.
//  Copyright © 2016 Eton Kan. All rights reserved.
//

import Foundation
import UIKit

class ShakePage: UIViewController {
  
    @IBOutlet weak var shakephone: UILabel!
    @IBOutlet weak var placedinqueue: UILabel!
    @IBOutlet weak var currentlyinqueue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shakephone.isHidden = false
        placedinqueue.isHidden = true
        currentlyinqueue.isHidden = true
    }
    /*
    func postDataToURL()
    {
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "authorization": "Basic Og==",
            "cache-control": "no-cache",
            "postman-token": "57360440-8cde-0e19-314a-edc1975c4b7f"
        ]
        
        let postData = NSMutableData(data: "text=meme".data(using: String.Encoding.utf8)!)
        postData.append("&user=yoyo".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://127.0.0.1:8080/messages/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
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
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            shakephone.isHidden = true
            placedinqueue.isHidden = false
            //Getting User's gender and ID
            
            //Storing User's gender, ID and current time to the server's data structure
            let postData = NSMutableData(data: "text=Eton".data(using: String.Encoding.utf8)!)
            postData.append("&user=Kan".data(using: String.Encoding.utf8)!)
            MainPage().postDataToURL(postData: postData as Data)
           
            //If number of entries >1 in the server's data structure, matching begin
            
        }
    }
    
}
