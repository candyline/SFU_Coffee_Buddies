//
//  File Name: BusTogether.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Eton Kan
//  Creation Date: Nov 18, 2016
//  List of Changes:
//      - Created by Eton Kan
//      - Implemented Bus Together Function
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 19, 2016
//
//  List of Bugs: none
//
//  Copyright © 2016 Eton Kan. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//Class to get and display BusTogether informations
//Author: Eton Kan
//Last Modifty: Nov 18,2016
class BusTogether: UIViewController
{
    @IBOutlet weak var busRouteDisplay: UILabel!
    @IBOutlet weak var busRouteLabel: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    @IBOutlet weak var busTimeOne: UILabel!
    @IBOutlet weak var busTimeTwo: UILabel!
    @IBOutlet weak var busTimeThree: UILabel!
    
    @IBOutlet weak var descriptionDisplayLower: UILabel!
    @IBOutlet weak var busTimeOneLower: UILabel!
    @IBOutlet weak var busTimeTwoLower: UILabel!
    @IBOutlet weak var busTimeThreeLower: UILabel!
    
    var stopNumber: String = "0"
    var stopNumber145Exchange: String = "51861"//upper bus loop 145 bay 1
    var stopNumber144Exchange: String = "52807"//upper bus loop 144 bay 3
    var stopNumber143Exchange: String = "52998"//upper bus loop 143 bay 4
    var stopNumber135Exchange: String = "53096"//upper bus loop 135 bay 1
    var stopNumberAllCentre: String = "51863"//lower bus loop for 135,143,144 and 145 buses
    var apiKey: String = "exyt3dACJAzO9wookvg5"
    var count: String = "3" //"&count=" + self.count +
    var routeNo: String = "0"
    //var timeFrame: String = "0" //"&timeframe=" + self.timeFrame
    var timeArray = [String]()
    var timeArrayLower = [String]()
    //This function grab data from Translink's API and display bus information to the user (SFU Transite Exchange only)
    //Author: Eton Kan
    //Last Modify: Nov 19,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Perparing bus numbers for Translink's API url
        self.busRouteLabel.text = userProfile.bus
        self.routeNo = userProfile.bus
        if (self.routeNo == "145")
        {
            self.stopNumber = self.stopNumber145Exchange
        }
        else if (self.routeNo == "144")
        {
            self.stopNumber = self.stopNumber144Exchange
        }
        else if (self.routeNo == "143")
        {
            self.stopNumber = self.stopNumber143Exchange
        }
        else if (self.routeNo == "135")
        {
            self.stopNumber = self.stopNumber135Exchange
        }
        else
        {
            print("This is not an SFU Bus")
            return
        }
        //Get next three bus time from Translink's API
        getNextThreeBusUpperAPI(busNum: userProfile.bus)
        
    }
    
    //This function next three buses time from Translink's API SFU Transit Exchange
    //Author: Eton Kan
    //Last Modify: Nov 19,2016
    //Known Bugs: none
    func getNextThreeBusUpperAPI (busNum: String)
    {
        //By default, translink api return the next six bus in the next 24 hours. However, I just want the next three buses
        let urlPath = URL(string:"http://api.translink.ca/rttiapi/v1/stops/" + self.stopNumber + "/estimates?apikey=" + self.apiKey +  "&routeNo=" + self.routeNo + "&count=" + self.count)!
        print(urlPath)
        var urlRequest = URLRequest(url: urlPath)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        //Requesting start
        Alamofire.request(urlRequest).responseJSON
            {
                response in
                //Testing if data available for grab
                switch response.result
                {
                case .success:
                    print("Able to connect to server and data found (getUserProfile)")
                    //Parsing the data taken from Translin's API
                    let dataBaseArray = JSON(response.result.value!)
                    //Getting time out from Translink's API response
                    for index in 0 ... dataBaseArray[0]["Schedules"].count
                    {
                        if let times = dataBaseArray[0]["Schedules"][index]["ExpectedLeaveTime"].string
                        {
                            self.timeArray.append(times)
                            print(self.timeArray[index])
                        }
                    }
                    //Displaying bus information to user
                    if (self.timeArray.count >= 3)
                    {
                        self.busTimeOne.text = self.timeArray[0]
                        self.busTimeTwo.text = self.timeArray[1]
                        self.busTimeThree.text = self.timeArray[2]
                    }
                    else if (self.timeArray.count == 2)
                    {
                        self.busTimeOne.text = self.timeArray[0]
                        self.busTimeTwo.text = self.timeArray[1]
                        self.busTimeThree.text = ""
                    }
                    else if (self.timeArray.count == 1)
                    {
                        self.busTimeOne.text = self.timeArray[0]
                        self.busTimeTwo.text = ""
                        self.busTimeThree.text = ""
                    }
                    else
                    {
                        self.busTimeOne.text = "No More Bus For Today"
                        self.busTimeTwo.text = ""
                        self.busTimeThree.text = ""
                    }
                    self.getNextThreeBusLowerAPI(busNum: userProfile.bus)

                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    //This function next three buses time from Translink's API for SFU Transportation Center
    //Author: Eton Kan
    //Last Modify: Nov 19,2016
    //Known Bugs: none
    func getNextThreeBusLowerAPI (busNum: String)
    {
        //By default, translink api return the next six bus in the next 24 hours. However, I just want the next three buses
        let urlPath = URL(string:"http://api.translink.ca/rttiapi/v1/stops/" + self.stopNumberAllCentre + "/estimates?apikey=" + self.apiKey +  "&routeNo=" + self.routeNo + "&count=" + self.count)!
        print(urlPath)
        var urlRequest = URLRequest(url: urlPath)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        //Requesting start
        Alamofire.request(urlRequest).responseJSON
            {
                response in
                //Testing if data available for grab
                switch response.result
                {
                case .success:
                    print("Able to connect to server and data found (getUserProfile)")
                    //Parsing the data taken from Translin's API
                    let dataBaseArray = JSON(response.result.value!)
                    //Getting time out from Translink's API response
                    for index in 0 ... dataBaseArray[0]["Schedules"].count
                    {
                        if let times = dataBaseArray[0]["Schedules"][index]["ExpectedLeaveTime"].string
                        {
                            self.timeArrayLower.append(times)
                            print(self.timeArrayLower[index])
                        }
                    }
                    //Displaying bus information to user
                    if (self.timeArrayLower.count >= 3)
                    {
                        self.busTimeOneLower.text = self.timeArrayLower[0]
                        self.busTimeTwoLower.text = self.timeArrayLower[1]
                        self.busTimeThreeLower.text = self.timeArrayLower[2]
                    }
                    else if (self.timeArrayLower.count == 2)
                    {
                        self.busTimeOneLower.text = self.timeArrayLower[0]
                        self.busTimeTwoLower.text = self.timeArrayLower[1]
                        self.busTimeThreeLower.text = ""
                    }
                    else if (self.timeArrayLower.count == 1)
                    {
                        self.busTimeOneLower.text = self.timeArrayLower[0]
                        self.busTimeTwoLower.text = ""
                        self.busTimeThreeLower.text = ""
                    }
                    else
                    {
                        self.busTimeOneLower.text = "No More Bus For Today"
                        self.busTimeTwoLower.text = ""
                        self.busTimeThreeLower.text = ""
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
}
