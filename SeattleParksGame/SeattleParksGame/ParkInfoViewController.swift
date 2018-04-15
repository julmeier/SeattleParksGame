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

    let userKey = Auth.auth().currentUser?.uid
    
    //variables to receive AnnotationPin attribute data from MapViewController
    var name: String?
    var address: String?
    var pmaid: String?
    var parkData: AnnotationPin?
    
    var visited: String?
    
    var dbReference: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    //arrays for holding park feature data:
    var allParkFeaturesArray: [String] = [ ]
    var allParkFeaturesSet: [String] = []
    var thisParkFeatures: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "SeattleParksFeatures", ofType: "json")
        let url = URL(fileURLWithPath: path!)

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let parkFeatures = try decoder.decode([ParkFeatures].self, from: data)
            for parkFeature in parkFeatures {
                // CREATED SET TO USE IN THE FeatureFilterVC PICKERVIEW:
                //allParkFeaturesArray.append(parkFeature.feature_desc)

                if parkFeature.pmaid == parkData?.pmaid {
                    thisParkFeatures.append(parkFeature.feature_desc)
                }
                
            }
        }
        catch {
            print("error try to convert park features data to JSON")
            print(error)
        }

        dbReference = Database.database().reference()
        
        //receives data from MapViewController and sets text to labels
        if let parkDataToDisplay = parkData {
            parkName.text = parkDataToDisplay.title
            parkAddress.text = parkDataToDisplay.address
            pmaid = parkDataToDisplay.pmaid
        }
        
        dbReference?.child("users").child(userKey!).child("parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.pmaid!) {
                self.visitStatus.text = "Visited!"
                self.visitStatusImage.image = UIImage(named: "park_visited-512")
                self.yesIVisitedButton.isHidden = true
                
            } else
            {
                self.visitStatus.text = "Not Yet Visited!"
                self.yesIVisitedButton.isHidden = false
                self.visitStatusImage.image = UIImage(named: "park_not_visited-512")
            }
        })
        
        self.tableView.tableFooterView = UIView()
        
    } //end of viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

//I VISITED BUTTON ACTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    @IBAction func changeVisitStatusPressed(_ sender: Any) {
        dbReference?.child("users").child(userKey!).child("parkVisits").child(pmaid!).setValue(true)
        viewDidLoad()
    }
    
//SHARE EVENT BUTTON ACTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    @IBAction func pressedShareBtn(_ sender: Any) {
        shareEvent()
    }
    
    func shareEvent() {
        let activityController = UIActivityViewController(activityItems: ["I just visited \(String(describing: parkName.text!))!  | To track how many Seattle Parks you've visited, download the app: Emerald City Ranger"], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

//PARK FEATURES TABLEVIEW<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.thisParkFeatures.count == 0 {
            parkFeaturesHeader.isHidden = true
        }
        return self.thisParkFeatures.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.thisParkFeatures[indexPath.row]
        return cell
    }
    
    
}
