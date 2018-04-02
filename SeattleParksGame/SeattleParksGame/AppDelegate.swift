//
//  AppDelegate.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/2/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, GIDSignInUIDelegate {

    var window: UIWindow?
    var databaseRef: DatabaseReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        //Google Sign-In:
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    //Added by Julia for Google Sign-in (Firebase Guide Step 4)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//            print("passing through application(_ appication: UIApplication, open url: URL.... in AppDelegate") //this never prints
//            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Entered didDisconnectWith in the AppDelegate")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to sign into Google: ", err.localizedDescription)
        } else {
            print("Successfully logged into Google: ", user)
        
            guard let idToken = user.authentication.idToken else {return}
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
     
            Auth.auth().signIn(with: credentials) { (user, error) in
                if let error = error {
                    print("Failed to create a Firebase User with Google account: ", error)
                    return
                }
                guard let uid = user?.uid else { return }
                guard let displayName = user?.displayName else {return}
                print("Successfully logged into Firebase with Google. User.uid: ", uid)
                print("User.email: \(String(describing: user?.email))")
                print("User.displayName: \(displayName)")
                
                self.databaseRef = Database.database().reference()
                
                self.databaseRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshot = snapshot.value as? NSDictionary
                    
                    if(snapshot == nil)
                    {
                        self.databaseRef.child("user_profiles").child(uid).child("displayName").setValue(displayName)
                        self.databaseRef.child("user_profiles").child(uid).child("email").setValue(user?.email)
                    }
                    
                    //let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                    
                    
                    self.window?.rootViewController?.performSegue(withIdentifier: "signInToNavController", sender: nil)
                    
                    print("Finished didSignInFor in AppDelegate")
                    
                })
            }
        }
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

