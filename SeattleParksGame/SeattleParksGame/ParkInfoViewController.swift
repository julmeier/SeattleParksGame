//
//  ParkInfoViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/2/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Foundation
import FirebaseDatabase

struct ParkFeatures: Codable {
    let pmaid: String
    //let hours: String
    let feature_desc: String
}

class ParkInfoViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource {

    @IBOutlet weak var parkName: UILabel!
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var visitStatus: UILabel!
    @IBOutlet weak var yesIVisitedButton: UIButton!
    @IBOutlet weak var parkImage: UIImageView!
    @IBOutlet weak var parkFeaturesHeader: UILabel!
    @IBOutlet weak var visitStatusImage: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    //get user data
    let userKey = Auth.auth().currentUser?.uid
    
    //variables to receive AnnotationPin attribute data from MapViewController
    var name: String?
    var address: String?
    var pmaid: String?
    var parkData: AnnotationPin?
    
    // this variable will be read in from the database
    var visited: String?
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    //arrays for holding park feature data:
    var allParkFeaturesArray: [String] = [ ]
    var allParkFeaturesSet: [String] = []
    var thisParkFeatures: [String] = []
    
    //features table:
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADD A METHOD HERE TO SEE IF USERKEY ACTUALLY EXISTS? DIRECT THEM TO ANOTHER METHOD THAT LEADS THEM TO SIGN IN PAGE, IF NOT LOGGED IN
        
        //CALLS FOR ALL DATA AND THEN SORTS ON THE PMAID:
        let path = Bundle.main.path(forResource: "SeattleParksFeatures", ofType: "json")
        print(path!)
        let url = URL(fileURLWithPath: path!)
        print(url)
        do {
            let data = try Data(contentsOf: url)
            //let dataString = String(data: data, encoding: .utf8)!
            //print(dataString)
            //print("dataString is above (prints all park)")
        
            let decoder = JSONDecoder()
            let parkFeatures = try decoder.decode([ParkFeatures].self, from: data)
            for parkFeature in parkFeatures {
                allParkFeaturesArray.append(parkFeature.feature_desc)

                if parkFeature.pmaid == parkData?.pmaid {
                    thisParkFeatures.append(parkFeature.feature_desc)
                }
                
            }
            allParkFeaturesSet = removeDuplicates(array: allParkFeaturesArray).sorted()
            print("allParkFeaturesSet:")
            print(allParkFeaturesSet)
            //print("THIS park's features:")
            //print(thisParkFeatures)
        
            //USES SELECTION OF PMAID TO DIRECTLY CALL JUST THAT PARK'S FEATURES:
            //let url_root = "https://data.seattle.gov/resource/ye65-jqxk.json?pmaid="
        }
        catch {
            print("error try to convert park features data to JSON")
            print(error)
        }

        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        //receives data from MapViewController and sets text to labels
        if let parkDataToDisplay = parkData {
            //print("Did it pass parkData correctly?")
            //print(parkDataToDisplay)
            print(parkDataToDisplay.title!)
            
            parkName.text = parkDataToDisplay.title
            parkAddress.text = parkDataToDisplay.address
            pmaid = parkDataToDisplay.pmaid
            print(pmaid!)
        }
        
        
        //finds value of visit status in the database and displays:
        //read in data from database to see if the park has been visited
        
        //READ AUTHENTICATED USER DATA:
        dbReference?.child("users").child(userKey!).child("parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
            //print("snapshot data")
            //print(snapshot)
            //print(snapshot.childrenCount)
            if snapshot.hasChild(self.pmaid!) {
                print("pmaid in the db")
                self.visitStatus.text = "Visited!"
                self.visitStatusImage.image = UIImage(named: "park_visited-512")
                self.yesIVisitedButton.isHidden = true
                
            } else
            {
                print("pmaid NOT in the db")
                self.visitStatus.text = "Not Yet Visited!"
                self.yesIVisitedButton.isHidden = false
                self.visitStatusImage.image = UIImage(named: "park_not_visited-512")
            }
        })
        
        //TESTUSER1 DATA:
//        dbReference?.child("users/testUser1/parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
//            print("snapshot data")
//            print(snapshot)
//            print(snapshot.childrenCount)
//            if snapshot.hasChild(self.pmaid!) {
//                print("pmaid in the db")
//                self.visitStatus.text = "Visited!"
//                self.visitStatusImage.image = UIImage(named: "park_visited-512")
//                self.yesIVisitedButton.isHidden = true
//
//            } else
//            {
//                print("pmaid NOT in the db")
//                self.visitStatus.text = "Not Yet Visited!"
//                self.yesIVisitedButton.isHidden = false
//                self.visitStatusImage.image = UIImage(named: "park_not_visited-512")
//            }
//        })
        
        self.tableView.tableFooterView = UIView()
        
    } //end of viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    @IBAction func changeVisitStatusPressed(_ sender: Any) {
        print("changeVisitStatus button tapped")
        
        //add pmaid to database
        //dbReference?.child("users").child("testUser1").child("parkVisits").child(pmaid!).setValue(true)
        dbReference?.child("users").child(userKey!).child("parkVisits").child(pmaid!).setValue(true)
        
        //remove value from database:
        //dbReference?.child("users").child("testUser1").child("parkVisits").child(pmaid!).setValue(nil)
        
        
        viewDidLoad()
    }
    
    
    @IBAction func pressedShareBtn(_ sender: Any) {
        shareEvent()
    }
    
    func shareEvent() {
        let activityController = UIActivityViewController(activityItems: ["I just visited \(String(describing: parkName.text!))!  | To track how many Seattle Parks you've visited, download the app: Emerald City Ranger"], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("PRINTING FROM THE numberOfRowsInSection func")
        print(thisParkFeatures)
        print(self.thisParkFeatures.count)
        if self.thisParkFeatures.count == 0 {
            parkFeaturesHeader.isHidden = true
        }
        
        return self.thisParkFeatures.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.thisParkFeatures[indexPath.row]
    
        //scrolling table AUTOMATICALLY to see all features:
        //let numberOfSections = tableView.numberOfSections
        //let numberOfRows = tableView.numberOfRows(inSection: numberOfSections-1)
        //let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        //self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
    
        //output
        return cell
    }
    
    
}
