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
    let zips = ["98107", "98108", "98121", "98133", "98178", "98102", "98118", "98106", "98101", "98136", "98122", "98103", "98126", "98104", "98112", "98199", "98144", "98146", "98115", "98125", "98119", "98177", "98109", "98117", "98105", "98116"]
    let hoods = ["Ballard", "Beacon Hill", "Belltown", "Bitterlake", "Bryn Mawr-Skyway", "Capitol Hill", "Columbia City", "Delridge", "Downtown", "Fauntleroy", "First Hill-Madrona", "Greenwood-Fremont-Greenlake", "High Point", "International District-Pioneer Square", "Madison Valley", "Magnolia", "Mount Baker", "Mount View-Burien", "Northeast", "Northgate", "Queen Anne", "Richmond Beach", "South Lake Union", "Sunset Hill-Whittier Heights", "University District-Laurelhurst", "West Seattle"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In HoodFilterVC viewDidLoad")
        
        //This outputs the arrays of zips and hood from the dictionary in alphabetical order of the neighborhood names.
//        var hoodZips = [String: String]()
//        for i in 0..<hoods.count {
//            hoodZips[hoods[i]] = zips[i]
//        }
//        print("hoodZips: \(hoodZips)")
//        let sortedHoodZips = Array(hoodZips).sorted(by: { $0.0 < $1.0 })
//        print("sortedHoodZips: \(sortedHoodZips)")
//        for (neighborhood, zip) in sortedHoodZips {
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
            //print("in segue to map")
            let destination = segue.destination as! MapViewController
            let chosenHood = chosenHoodLbl.text
            let chosenZips = (badges as NSDictionary).allKeys(for: chosenHood!) as! [String]
            let chosenZip = chosenZips[0]
            print("chosenZip: \(chosenZip)")
            destination.chosenZip = chosenZip
            destination.chosenHood = chosenHood!
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return badges.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenHoodLbl.text = hoods[row]
    }



}
