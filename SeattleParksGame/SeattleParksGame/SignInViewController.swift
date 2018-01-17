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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleButtons()
 
    }

    //for refactoring later (call this function from viewDidLoad)
    fileprivate func setupGoogleButtons() {
        
//        let googleBtn = GIDSignInButton()
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        //programmatic:
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y:116, width: view.frame.width-32, height:50)
        //for the next button, just add 66 to the y value to put it perfectly underneath this one.
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //example if you want to create a custom google button
//        let customButton = UIButton(type: .system)
//        customButton.frame = CGRect(x:16, y:116+66, width: view.frame.width-32, height:50)
//        customButton.backgroundColor = .orange
//        view.addSubview(customButton)

    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let mapViewController = MapViewController()
                self.present(mapViewController, animated: true, completion: nil)
            } else {
                // no user is signed in
                self.login()
            }
        }
    }


}