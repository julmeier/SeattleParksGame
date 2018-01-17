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


class UserProgressViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource {
    
    //collection view:
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    
    
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
    var parksByZip = [String: [String]]()
    var totalParks = 0
    var totalDuplicateParks = 0
    var parkZipcodes = [String]()
    var numberOfParksByZipDict = [String: Int]()
    var numberOfVisitsByZipDict = [String: Int]()
    var allPmaids = [String]()
    
    //variables to receive data passed from MapView
    var allAnnotationPins: [AnnotationPin] = []
    //var allAnnotationPinsSet: [AnnotationPin] = []
    
    //storyboard variables
    @IBOutlet weak var numberVisited: UILabel!
    @IBOutlet weak var allParksDisplay: UILabel!
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badgeCollectionView.dataSource = self
        
        //print("Did it pass parkData correctly?")
        //print(allAnnotationPins)
        print("allAnnotationPins.count BEFORE DELETE")
        print(allAnnotationPins.count)
        //let allAnnotationPinsSet = self.removeDuplicates(array: self.allAnnotationPins)
        //print("allAnnotationPinsSet")
        //print(allAnnotationPinsSet.count)
        
        var index = 0
        for pin in allAnnotationPins {
            
            if allPmaids.contains(pin.pmaid!) {
                allAnnotationPins.remove(at: index)
            } else {
                allPmaids.append(pin.pmaid!)
            }
            index += 1
        }
        
        print("allAnnotationPins.count AFTER DELETE")
        print(allAnnotationPins.count)
        
        for pin in allAnnotationPins {
            //print("\(pin.title!) - \(pin.zip_code!) - \(pin.visitStatus!)")
            
            if (parksByZip[pin.zip_code!] != nil) {
                //parksByZip[pin.zip_code!].append(pin.title!)
                parksByZip[pin.zip_code!]?.append(pin.title!)
            }
            else {
                parksByZip[pin.zip_code!] = [pin.title!]
            }
            
            if pin.visitStatus == "true" {
                if (numberOfVisitsByZipDict[pin.zip_code!] != nil) {
                    numberOfVisitsByZipDict[pin.zip_code!]! += 1
                }
                else {
                    numberOfVisitsByZipDict[pin.zip_code!] = 1
                }
            }

            totalParks += 1
            
        }
        //print("parksByZip:")
        //print(parksByZip)
        
        print("totalParks:")
        print(totalParks)
        self.allParksDisplay.text = String(totalParks)
        
        print("numberOfVisitsByZipDict:")
        print(numberOfVisitsByZipDict)
        
        for (zip, parks) in parksByZip {
            let count = parks.count
            print("zip: \(zip), count: \(count)")
            parkZipcodes.append(zip)
            numberOfParksByZipDict[zip] = count
        }


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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as! BadgeCollectionViewCell
        
        let zip = parkZipcodes[indexPath.row]
        let hood = badges[parkZipcodes[indexPath.row]]
        cell.badgeNameLabel.text = hood
        
        let zipCount = numberOfParksByZipDict[zip]
        let visitCount = numberOfVisitsByZipDict[zip]
        
        if visitCount == nil {
            cell.badgeStatsLabel.text = "0 of \(zipCount!)"
        }
        else {
            cell.badgeStatsLabel.text = "\(visitCount!) of \(zipCount!)"
        }
        
        //If I want to layer the X image over another, create another ImageView in the storyboard to assign that image to.
        if visitCount == zipCount {
            cell.badgeImageView.image = UIImage(named: hood!)
        } else {
            cell.badgeImageView.image = UIImage(named: "circle_X_black_512")
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeDuplicates(array: [AnnotationPin]) -> [AnnotationPin] {
        var encountered = Set<AnnotationPin>()
        var result: [AnnotationPin] = []
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
        print("removeDuplicates result:")
        print(result.count)
        return result
    }
    
}
