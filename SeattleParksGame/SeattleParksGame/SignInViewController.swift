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
        print("In SignInVC viewDidLoad")
        setupGoogleButtons()
    }
    
    override func viewWillAppear(_ animated: Bool = true) {
        super.viewWillAppear(animated)
        print("In SignInVC viewWillAppear")
    }

    fileprivate func setupGoogleButtons() {
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y:116, width: view.frame.width-32, height:50)
        //to add another sign-in button, just add 66 to the y value to put it perfectly underneath this one.
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
//        checkLoggedIn()
    }
    
//    func checkLoggedIn() {
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil {
//                let mapViewController = MapViewController()
//                self.present(mapViewController, animated: true, completion: nil)
//            }
////            else {
////                 //no user is signed in
////                self.login()
////            }
//        }
//    }
    
//    func pushTomainView() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
//        self.show(vc, sender: nil)
//    }


}
