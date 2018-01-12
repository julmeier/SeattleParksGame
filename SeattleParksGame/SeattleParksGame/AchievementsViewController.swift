//
//  AchievementsViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/8/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseDatabase

class AchievementsViewController: UIViewController {
    
    //storyboard object variables
    @IBOutlet weak var numberVisited: UILabel!

    //Firebase database references:
    var dbReference: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
