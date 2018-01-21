//
//  FiltersViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/20/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //Outlets
    @IBOutlet weak var featuresPickerView: UIPickerView!
    @IBOutlet weak var hoodPickerView: UIPickerView!
    
    @IBOutlet weak var chosenHoodLbl: UILabel!
    @IBOutlet weak var chosenFeatureLbl: UILabel!
    
    //Variables
    var features = [String]()
    var hoods = [String]()
    var AllAnnotationPins = [AnnotationPin]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuresPickerView.delegate = self
        featuresPickerView.dataSource = self
        
        hoodPickerView.delegate = self
        hoodPickerView.dataSource = self
        
        
        

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
