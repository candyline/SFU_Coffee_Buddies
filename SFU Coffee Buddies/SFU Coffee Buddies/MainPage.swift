//
//  ViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-11.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit

class MainPage: UIViewController {

    let Serverhost = NSURL(string: "http://127.0.0.1:8080/messages/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //This function takes in appended strings using NSMutableData() and post it on to the localhost
    //Author: Eton Kan
    //Last Update: Nov 4, 2016
    func postDataToURL(postData:Data)
    {
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "authorization": "Basic Og==",
            "cache-control": "no-cache",
            "postman-token": "57360440-8cde-0e19-314a-edc1975c4b7f"
        ]
    
        let request = NSMutableURLRequest(url: Serverhost! as URL,                                          cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

