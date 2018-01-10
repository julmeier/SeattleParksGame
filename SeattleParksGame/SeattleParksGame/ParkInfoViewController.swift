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
                //print("PRINTING OUTSIDE OF IF:")
                //print(parkFeature)
                //print(parkFeature.pmaid)
                if parkFeature.pmaid == parkData?.pmaid {
                    print("Features inside if statement:")
                    print(parkFeature.feature_desc)
                    thisParkFeatures.append(parkFeature.feature_desc)
                }
                
            }
            allParkFeaturesSet = removeDuplicates(array: allParkFeaturesArray).sorted()
            //print(allParkFeaturesSet)
            print("THIS park's features:")
            print(thisParkFeatures)
        }
        catch {
            print("error try to convert park features data to JSON")
            print(error)
        }

        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        //TEST DATA:
        //parkName.text = "Magnuson Park"
        //parkImage.image = UIImage(named: "GasworksHD-landscape")
        //or use Image Literal to choose image from Asset catalogue
        
        //receives data from MapViewController and sets text to labels
        if let parkDataToDisplay = parkData {
            print("Did it pass parkData correctly?")
            print(parkDataToDisplay)
            print(parkDataToDisplay.title!)
            
            parkName.text = parkDataToDisplay.title
            parkAddress.text = parkDataToDisplay.address
            pmaid = parkDataToDisplay.pmaid
            print(pmaid!)
        }
        
//        if let nameToDisplay = name {
//            parkName.text = nameToDisplay
//        }
//        if let addressToDisplay = address {
//            parkAddress.text = addressToDisplay
//        }
        
        //finds value of visit status in the database and displays:
        //read in data from database to see if the park has been visited
        dbReference?.child("users/testUser1/parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.pmaid!) {
                print("pmaid in the db")
                self.visitStatus.text = "Visited!"
                //self.park_bench_sunrise.isHidden = false
                self.yesIVisitedButton.isHidden = true
              
            } else 
            {
                print("pmaid NOT in the db")
                self.visitStatus.text = "Not Yet Visited!"
                self.yesIVisitedButton.isHidden = false
                //self.park_bench_sunrise.isHidden = false
            }
        })
        
    } //end of viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    @IBAction func changeVisitStatusPressed(_ sender: Any) {
        print("changeVisitStatus button tapped")
        
        //add pmaid to database
        dbReference?.child("users").child("testUser1").child("parkVisits").child(pmaid!).setValue(true)
        
        //remove value from database:
        //dbReference?.child("users").child("testUser1").child("parkVisits").child(pmaid!).setValue(nil)
        
        
        viewDidLoad()
    }
    
    //tutorial shows this version instead. Why no explicit return?
//    @IBAction func changeVisitStatusPressed(_ sender: AnyObject) -> Void {
//    }
    
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
