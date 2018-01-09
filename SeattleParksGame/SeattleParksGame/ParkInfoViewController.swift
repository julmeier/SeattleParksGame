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

class ParkInfoViewController: UIViewController {

    @IBOutlet weak var parkName: UILabel!
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var visitStatus: UILabel!
    //@IBOutlet weak var parkImage: UIImageView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "SeattleParksFeatures", ofType: "json")
        print(path)
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
                //if parkFeature.pmaid == pmaid
                print(parkFeature.feature_desc)
            }
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
            } else 
            {
                print("pmaid NOT in the db")
                self.visitStatus.text = "Not Yet Visited!"
            }
        })
        
    } //end of viewDidLoad

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
    
    
}
