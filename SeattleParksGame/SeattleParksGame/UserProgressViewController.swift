//
//  UserProgressViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/12/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit

class UserProgressViewController: UIViewController {
    
    //storyboard variables
    @IBOutlet weak var numberVisited: UILabel!
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberVisited.text = "Hello world"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
