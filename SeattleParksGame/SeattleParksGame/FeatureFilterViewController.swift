//
//  FeatureFilterViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/23/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit

class FeatureFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let allFeaturesSet = ["Adult Fitness Equipment", "Baseball/Softball", "Basketball (Full)", "Basketball (Half)", "Bike Polo", "Bike Trail", "Boat Launch (Hand Carry)", "Boat Launch (Motorized)", "Boat Moorage", "Community Building", "Community Center", "Creek", "Cricket", "Decorative Fountain", "Disc Golf", "Dog Off Leash Area", "Environmental Learning Center", "Fire Pit", "Fishing", "Flag Football", "Football", "Garden", "Golf", "Green Space", "Guarded Beach", "Hiking Trails", "Historic Landmark", "Horseshoe Pits", "Lacrosse", "Lawn Bowling", "Marination Ma Kai", "Model Boat Pond", "NO Beach Access", "P-Patch Community Garden", "Paths", "Paths (ADA Compliant)", "Pesticide Free", "Pickleball Court", "Picnic Sites", "Picnic Sites (ADA Compliant)", "Play Area", "Play Area (ADA Compliant)", "Pool (Indoor)", "Pool (Outdoor)", "Rental Facility", "Restrooms", "Restrooms (ADA Compliant)", "Rugby", "Scuba Diving", "Skatepark", "Skatespot", "Soccer", "T-Ball", "Tennis Backboard (Outdoor)", "Tennis Court (Outdoor)", "Tennis Lights", "Track", "Ultimate", "View", "Wading Pool or Water Feature", "Waterfront", "Weddings and Ceremonies", "Woods"]
    
    //variables and outlets
    @IBOutlet weak var featurePickerView: UIPickerView!
    @IBOutlet weak var chosenFeatureLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In FeatureFilterVC viewDidLoad")
        print(allFeaturesSet.count)
        
        featurePickerView.delegate = self
        featurePickerView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "featureFilterToMapSegue" {
            print("in segue to map")
            let destination = segue.destination as! MapViewController
            let chosenFeature = chosenFeatureLbl.text
            print("chosenFeature: \(String(describing: chosenFeature))")
            destination.chosenFeature = chosenFeature!
        }
        
    }
    
    @IBAction func featureSelectBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "featureFilterToMapSegue", sender: self)
    }
    
    

    //CREATING THE PICKER VIEW:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allFeaturesSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allFeaturesSet[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenFeatureLbl.text = allFeaturesSet[row]
    }

}
