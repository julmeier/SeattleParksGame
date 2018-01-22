//
//  FiltersViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/20/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit


protocol HoodFilterDelegate {
    func userDidChooseHood(data: String)
}

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var delegate: HoodFilterDelegate? = nil
    
    //Outlets
    @IBOutlet weak var hoodPickerView: UIPickerView!
    @IBOutlet weak var chosenHoodLbl: UILabel!
    
    //Variables
    //either generate the hoodNames SET here or have it created in Map and sent here (and to the Badges VC eventually
    var hoodNames = [String]()
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoodPickerView.delegate = self
        hoodPickerView.dataSource = self
        
        if delegate != nil {
            if chosenHoodLbl.text != nil {
                let chosenHood = chosenHoodLbl.text
                let chosenZips = (badges as NSDictionary).allKeys(for: chosenHood!) as! [String]
                let chosenZip = chosenZips[0]
                print("choseZip: \(chosenZip)")
                delegate?.userDidChooseHood(data: chosenZip)
                dismiss(animated: true, completion: nil)
            }
        }
        

        // Do any additional setup after loading the view.
    }

    
    //FILTER BY PARK FEATURES PICKERVIEW METHODS:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //return countries.count
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        <#code#>
        
        //return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        <#code#>
        //chosenHoodLbl.text = countries[row]
    }

    
    


}
