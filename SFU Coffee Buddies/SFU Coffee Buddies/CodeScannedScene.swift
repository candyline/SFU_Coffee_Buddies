//
//  CodeScannedScene.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-12-04.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit

class CodeScannedScene: UIViewController {

    @IBOutlet weak var discountCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        discountCodeLabel.text = randomString(length: 5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Purpose : Random code generator, used to randomly produce QR Codes
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
