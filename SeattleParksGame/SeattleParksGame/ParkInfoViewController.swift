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
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //parkName.text = "Magnuson Park"
        //parkImage.image = UIImage(named: "GasworksHD-landscape")
        //or use Image Literal to choose image from Asset catalogue
        
        if let nameToDisplay = name {
            parkName.text = nameToDisplay
        }
        
    }

    @IBAction func changeVisitStatusPressed(_ sender: Any) {
        print("changeVisitStatus button tapped")
        
    }
    
    //tutorial shows this version instead. Why no explicit return?
//    @IBAction func changeVisitStatusPressed(_ sender: AnyObject) -> Void {
//    }
    
}
