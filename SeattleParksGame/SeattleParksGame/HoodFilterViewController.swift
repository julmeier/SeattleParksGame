//
//  HoodFilterViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/20/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit

protocol HoodFilterDelegate {
    func userDidChooseHood(data: String)
}

class HoodFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: HoodFilterDelegate? = nil
    
    //Outlets:
    
    @IBOutlet weak var hoodPickerView: UIPickerView!
    @IBOutlet weak var chosenHoodLbl: UILabel!
    @IBOutlet weak var selectHoodBtn: UIButton!
    
    //Variables
    //either generate the hoodNames SET here or have it created in Map and sent here (and to the Badges VC eventually
    var allHoodNames = [String]()
    var allZipcodes = [String]()
    var allAnnotationPins = [AnnotationPin]()
    let allFeaturesSet = ["Adult Fitness Equipment", "Baseball/Softball", "Basketball (Full)", "Basketball (Half)", "Bike Polo", "Bike Trail", "Boat Launch (Hand Carry)", "Boat Launch (Motorized)", "Boat Moorage", "Community Building", "Community Center", "Creek", "Cricket", "Decorative Fountain", "Disc Golf", "Dog Off Leash Area", "Environmental Learning Center", "Fire Pit", "Fishing", "Flag Football", "Football", "Garden", "Golf", "Green Space", "Guarded Beach", "Hiking Trails", "Historic Landmark", "Horseshoe Pits", "Lacrosse", "Lawn Bowling", "Marination Ma Kai", "Model Boat Pond", "NO Beach Access", "P-Patch Community Garden", "Paths", "Paths (ADA Compliant)", "Pesticide Free", "Pickleball Court", "Picnic Sites", "Picnic Sites (ADA Compliant)", "Play Area", "Play Area (ADA Compliant)", "Pool (Indoor)", "Pool (Outdoor)", "Rental Facility", "Restrooms", "Restrooms (ADA Compliant)", "Rugby", "Scuba Diving", "Skatepark", "Skatespot", "Soccer", "T-Ball", "Tennis Backboard (Outdoor)", "Tennis Court (Outdoor)", "Tennis Lights", "Track", "Ultimate", "View", "Wading Pool or Water Feature", "Waterfront", "Weddings and Ceremonies", "Woods"]
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
    let zips = ["98115", "98117", "98105", "98178", "98199", "98112", "98144", "98107", "98103", "98177", "98119", "98118", "98125", "98106", "98109", "98116", "98146", "98133", "98122", "98121", "98104", "98108", "98126", "98136", "98101", "98102"]
    let hoods = ["Northeast", "Sunset Hill-Whittier Heights", "University District-Laurelhurst", "Bryn Mawr-Skyway", "Magnolia", "Madison Valley", "Mount Baker", "Ballard", "Greenwood-Fremont-Greenlake", "Richmond Beach", "Queen Anne", "Columbia City", "Northgate", "Delridge", "South Lake Union", "West Seattle", "Mount View-Burien", "Bitterlake", "First Hill-Madrona", "Belltown", "International District-Pioneer Square", "Beacon Hill", "High Point", "Fauntleroy", "Downtown", "Capitol Hill"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In HoodFilterVC viewDidLoad")
        
//        for (zip,neighborhood) in badges {
//            allHoodNames.append(neighborhood)
//            allZipcodes.append(zip)
//        }
//        print(allHoodNames)
//        print(allZipcodes)
        
        //set up UIPickerView
        hoodPickerView.delegate = self
        hoodPickerView.dataSource = self
        
    }
    
    @IBAction func hoodSelectBtnPressed(_ sender: Any) {
        if delegate != nil {
            if chosenHoodLbl.text != nil {
                print("in hoodSelectBtnPressed")
                let chosenHood = chosenHoodLbl.text
                
                let chosenZips = (badges as NSDictionary).allKeys(for: chosenHood!) as! [String]
                let chosenZip = chosenZips[0]
                print("chosenZip: \(chosenZip)")
                delegate?.userDidChooseHood(data: chosenZip)
                performSegue(withIdentifier: "hoodFilterToMapSegue", sender: self)
                //I think this is what was sending me back to the login view?
                //dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hoodFilterToMapSegue" {
            print("in segue to map")
            let destination = segue.destination as! MapViewController
            let chosenHood = chosenHoodLbl.text
            let chosenZips = (badges as NSDictionary).allKeys(for: chosenHood!) as! [String]
            let chosenZip = chosenZips[0]
            print("chosenZip: \(chosenZip)")
            destination.chosenZip = chosenZip
            destination.chosenHood = chosenHood!
        }

    }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        print("in unwind")
//    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return badges.count
        //return countries.count
     
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoods[row]
        //return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //chosenHoodLbl.text = countries[row]
        chosenHoodLbl.text = hoods[row]
    }



}
