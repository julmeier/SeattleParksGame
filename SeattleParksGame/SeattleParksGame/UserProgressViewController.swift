//
//  UserProgressViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/12/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation
import MapKit


class UserProgressViewController: UIViewController, MKMapViewDelegate {
    
    //badges dictionary
    let badges = ["98101": "Downtown",
        "98102": "Capitol Hill",
        "98103": "Greenwood-Fremont-Greenlake",
        "98104": "International District-Pioneer Square",
        "98105": "University District-Laurelhurst",
        "98106": "Delridge",
        "98107": "Ballard",
        "98108": "Beacon Hill",
        "98109": "South Lake Union",
        "98112": "Madison Valley",
        "98115": "Northeast",
        "98116": "West Seattle",
        "98117": "Sunset Hill-Whittier Heights",
        "98118": "Columbia City",
        "98119": "Queen Anne",
        "98121": "Belltown",
        "98122": "First Hill-Madrona",
        "98125": "Northgate",
        "98126": "High Point",
        "98133": "Bitterlake",
        "98136": "Fauntleroy",
        "98144": "Mount Baker",
        "98146": "Mount View-Burien",
        "98177": "Richmond Beach",
        "98178": "Bryn Mawr-Skyway",
        "98199": "Magnolia"]
    let parksByZip = [String: [String]]()
    
    //variables to receive data passed from MapView
    var allAnnotationPins: [AnnotationPin] = []
    
    //storyboard variables
    @IBOutlet weak var numberVisited: UILabel!
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //receives data from MapViewController
            print("Did it pass parkData correctly?")
            print(allAnnotationPins)
        for pin in allAnnotationPins {
            print("\(pin.title!) - \(pin.zip_code!))")
        }
            //print(parkDataToDisplay.title!)
            //pmaid = parkDataToDisplay.pmaid

        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        //display the number of parks visited:
        dbReference?.child("users/testUser1/parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
            //print("snapshot.childrenCount:")
            //print(snapshot.childrenCount)
            let numberVisitedFromDB = snapshot.childrenCount
            self.numberVisited.text = String(numberVisitedFromDB)
            
        })
        
        //diplay the entire collction of possible badges user can earn
        //icons distinguish whether user has earned them yet or not
        //may show the number of parks needed to earn each badge (ex. achieved 6/7 parks - only 1 to go!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
