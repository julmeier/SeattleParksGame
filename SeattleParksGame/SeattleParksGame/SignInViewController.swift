//
//  SignInViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/16/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var googleBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleButtons()
 
    }

    //for refactoring later (call this function from viewDidLoad)
    fileprivate func setupGoogleButtons() {
        
        let googleBtn = GIDSignInButton()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //programmatic:
//        let googleButton = GIDSignInButton()
//        googleButton.frame = CGRect(x:16, y:116, width: view.frame.width-32, height:50)
//        //for the next button, just add 66 to the y value to put it perfectly underneath this one.
//        view.addSubview(googleButton)
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        //example if you want to create a custom google button
//        let customButton = UIButton(type: .system)
//        customButton.frame = CGRect(x:16, y:116+66, width: view.frame.width-32, height:50)
//        customButton.backgroundColor = .orange
//        view.addSubview(customButton)

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
