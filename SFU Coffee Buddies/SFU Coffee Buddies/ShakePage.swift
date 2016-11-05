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
            let postData = NSMutableData(data: "text=David".data(using: String.Encoding.utf8)!)
            postData.append("&user=MAOOOO".data(using: String.Encoding.utf8)!)
            MainPage().postDataToURL(postData: postData as Data)
           
            //If number of entries >1 in the server's data structure, matching begin
            
        }
    }
    
}
