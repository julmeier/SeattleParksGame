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
    
    
}
