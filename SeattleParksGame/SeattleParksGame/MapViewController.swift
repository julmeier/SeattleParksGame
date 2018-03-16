//
//  MapViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/2/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Foundation
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import GoogleSignIn



//=======IMPORTS SECRETS FILE=======
let path = Bundle.main.path(forResource: "secrets", ofType: "plist" )
let dict = NSDictionary(contentsOfFile: path!)

//======= loads the dictionary of the secrets file=========
let apiKey = dict!.object(forKey: "app_token") as! String

struct ParkAddress: Codable {
    let pmaid: String
    let name: String
    let address: String
    let zip_code: String
    let x_coord: String
    let y_coord: String
}

class  MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GIDSignInUIDelegate, HoodFilterDelegate {

    //get user data
    let userKey = Auth.auth().currentUser?.uid

    //Mapping variables:
    @IBOutlet weak var mapView: MKMapView!
    var tree: AnnotationPin!
    var pin: AnnotationPin!
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    
    //variable to hold annotation when it's passed to ParkInfoViewController
    var passedAnnotation: AnnotationPin?
    
    //variable to hold collection of zip codes
    var zipCodesAll: [String] = []
    var zipCodesSet: [String] = []
    //var zipCodeDictionary: [Dictionary<String, String>] = []
    
    //holds array of AnnotationPins
    var allAnnotationPins: [AnnotationPin?] = []
    
    //Filter variables & outlets
    //receive data from other views:
    var chosenZip = String()
    var chosenHood = String()
    var chosenFeature = String()
    //outlets:
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var topFilterBtn: UIButton!
    @IBOutlet weak var bottomFilterBtn: UIButton!
    //images:
    let filterHoodImage = UIImage(named: "filter4-neighborhood") as UIImage?
    let filterFeatureImage = UIImage(named: "filter4-parkfeature") as UIImage?
    let clearFilterImage = UIImage(named: "clear_filter") as UIImage?
    //boolean- user choice
    var filterHoodOn = false
    var filterFeatureOn = false
    //processing variables:
    var parksWithChosenFeaturesSet = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(pressedInfoBtn))
        
        //receives the zip from the hoodfilterVC
        let filterZip = chosenZip
        let filterHood = chosenHood
    
        //receives the feature from the featureFilterVC
        let filterFeature = chosenFeature
        
        if filterZip != "" {
            topFilterBtn.setImage(clearFilterImage, for: .normal)
            bottomFilterBtn.setImage(filterHoodImage, for: .normal)
            filterLbl.text = filterHood
            filterFeatureOn = false
            filterHoodOn = true
        } else if filterFeature != "" {
            topFilterBtn.setImage(clearFilterImage, for: .normal)
            bottomFilterBtn.setImage(filterFeatureImage, for: .normal)
            filterLbl.text = filterFeature
            filterHoodOn = false
            filterFeatureOn = true
        } else if filterFeature == "" && filterZip == "" {
            topFilterBtn.setImage(filterFeatureImage, for: .normal)
            bottomFilterBtn.setImage(filterHoodImage, for: .normal)
            filterLbl.isHidden = true
            filterHoodOn = false
            filterFeatureOn = false
        }
        
        //Logout button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //Logout user that is not logged in
        //COMMENTED THIS OUT DURING FILTERING BECAUSE IT SIGNS USER OUT WHEN THEY RETURN FROM HOOD FILTER PAGE:
//        if userKey == nil {
//            perform(#selector(handleLogout), with: nil, afterDelay: 0)
//        }
        
        //delegate needed for custom pin
        self.mapView?.delegate = self
        
        //See blue dot of user location (not visible in the simulator, but works on the phone)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        let initialLocation = CLLocation(latitude: 47.6074717, longitude: -122.3352511)
        zoomMapOn(location: initialLocation)
        
        self.mapView?.removeAnnotations(mapView.annotations)
        
        //retrieving JSON data from local file SeattleParksAddresses.json:
        //        let path = Bundle.main.path(forResource: "SeattleParksAddresses", ofType: "json")
        //        let url = URL(fileURLWithPath: path!)
        //        do {
        //            let data = try Data(contentsOf: url)
        //print(String(data: data, encoding: .utf8)!)
        //            let dataString = String(data: data, encoding: .utf8)!
        //            print(dataString)
        //            print("dataString is above (prints all park)")
        //
        //            let decoder = JSONDecoder()
        //            let parks = try decoder.decode([ParkAddress].self, from: data)
        
        //Retrieving data from SODAClient:
        //let client = SODAClient(domain: "data.seattle.gov", token: apiKey)
        
        //changed from: let fuelLocations = client.queryDataset("alternative-fuel-locations")
        //let parksFromAPI = client.query(dataset: "ajyh-m2d3")
    
//        parksFromAPI.orderAscending("pmaid").get { res in
//            switch res {
//            case .dataset (let apiData):
//                //print(apiData)
//                // Update our data
//                //self.datum = datum
//                for datum in apiData {
//                    //print(datum)
//                    print("DATUM:")
//                    print(datum["name"]!)
//                    print(datum["pmaid"]!)
//                }
//
//            case .error (let err):
//                let errorMessage = (err as NSError).userInfo.debugDescription
//                let alertController = UIAlertController(title: "Error Refreshing", message: errorMessage, preferredStyle:.alert)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
        
        var parksWithChosenFeature = [String]()
        if filterFeatureOn {
            let path = Bundle.main.path(forResource: "SeattleParksFeatures", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let parkFeatures = try decoder.decode([ParkFeatures].self, from: data)
                for parkFeature in parkFeatures {
                    if parkFeature.feature_desc == filterFeature {
                        parksWithChosenFeature.append(parkFeature.pmaid)
                    }
                    
                }
                parksWithChosenFeaturesSet = Set(parksWithChosenFeature.map { $0 })
                
                //USES SELECTION OF PMAID TO DIRECTLY CALL JUST THAT PARK'S FEATURES:
                //let url_root = "https://data.seattle.gov/resource/ye65-jqxk.json?pmaid="
            }
            catch {
                print("error try to convert park features data to JSON")
                print(error)
            }
            
        }
        
      
        //retrieving JSON data from API directly (without a key)
        let seattleParksAddressesUrl = "https://data.seattle.gov/resource/ajyh-m2d3.json"
        guard let url = URL(string: seattleParksAddressesUrl) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let parks = try decoder.decode([ParkAddress].self, from: data)
                
                //clears pins?
                self.allAnnotationPins = []
                self.allAnnotationPins.removeAll()
                //print("allAnnotationPins:")
                //print(self.allAnnotationPins)
                //print("chosenZip: \(self.chosenZip)")
                

                for park in parks {
                    
                    //print("Park name is: \(park.name)")
                    let long = (park.x_coord as NSString).doubleValue
                    let lat = (park.y_coord as NSString).doubleValue
                    
                    //read in data from database to see if the park has been visited
                    self.dbReference?.child("users").child(self.userKey!).child("parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(park.pmaid) {
                            //print("pmaid in the db:")
                            //print(park.pmaid)
                            self.tree = AnnotationPin(
                                title: park.name,
                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                imageName: "green-cloud-tree-32.png",
                                pmaid: park.pmaid,
                                address: park.address,
                                zip_code: park.zip_code,
                                visitStatus: "true"
                            )
                            self.allAnnotationPins.append(self.tree)
                        } else {
                            //print("pmaid NOT in the db:")
                           // print(park.pmaid)
                            self.tree = AnnotationPin(
                                title: park.name,
                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                imageName: "purple-cloud-tree-32.png",
                                pmaid: park.pmaid,
                                address: park.address,
                                zip_code: park.zip_code,
                                visitStatus: "false"
                            )
                            self.allAnnotationPins.append(self.tree)
                        } //end of else

                        //POPULATES MAP BASED ON FILTER VALUES:
                        if filterZip == "" && filterFeature == "" {
                            self.mapView?.addAnnotation(self.tree)
                        } else if filterZip != "" {
                            if self.tree.zip_code == filterZip {
                                self.mapView?.addAnnotation(self.tree)
                            }
                        } else if filterFeature != "" {
                            if self.parksWithChosenFeaturesSet.contains(self.tree.pmaid!) {
                                self.mapView?.addAnnotation(self.tree)
                                print("MAPPED PMAID \(self.tree.pmaid!)")
                            }
                        } else {
                            print("Mapping error at line 280")
                        }
                    }) //end of dbReference?.child
                } //end of for park in parks
            
            } //end of do
            catch {
                print("error try to convert park address data to JSON")
                print(error)
            } //end of catch
            
            //create set of zip codes for Achievements page:
            //self.zipCodesSet = self.removeDuplicates(array: self.zipCodesAll).sorted()
            //print(self.zipCodesSet)
        
        }.resume()

        print("FINISHED viewDidLoad")
    }
    
    
    @IBAction func pressedInfoBtn(_ sender: Any) {
        print("info button pressed!")
        performSegue(withIdentifier: "infoVCSegue", sender: self)
    }
    
    
//MAPVIEW SETUP <<<<<<<<<<<<<<<<<<<<<<<<<<

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKAnnotation) {
            print("Not registered as MKAnnotation")
            return nil
        }
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "parkIdentifier")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "parkIdentifier")
            annotationView?.canShowCallout = true
        }
        else
        {
            annotationView?.annotation = annotation
        }
        let cpa = annotation as! AnnotationPin
        annotationView!.image = UIImage(named: cpa.imageName!)
        //let buttonImage = UIImage(named: "museum-cross-signal-of-orientation-for-map-32.png")
        //let button = UIButton(type: .custom)
        let button = UIButton(type:.infoDark) as UIButton
        annotationView!.rightCalloutAccessoryView = button
        
        
        //THIS DIDN'T WORK. The pin location changes as you zoom because the positioning is a function of the image height.
        //annotationView?.centerOffset = CGPoint(x:0, y:((annotationView?.frame.size.height)!/2))
        //annotationView?.centerOffset = CGPoint(x:0, y:(-imageHeight/2))
        
        //THIS WORKS!
        //centers the image so that the bottom of the image matches with coordinate:
        annotationView?.layer.anchorPoint = CGPoint(x:0.5, y:1.0);
        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
        
        //get the annotation, which is a parameter
        passedAnnotation = view.annotation as? AnnotationPin
        
        //perform manual segue
        performSegue(withIdentifier: "parkDetails", sender: self)
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
    }
    
    private let regionRadius: CLLocationDistance = 4000 //1km = 1000

    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView?.setRegion(coordinateRegion, animated:true)
    }
    

//NEIGHBORHOOD FILTER DELEGATE FUNCTIONS:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    func userDidChooseHood(data: String) {
        //chosenZip = data
        //filterLbl.text = data
        //print("chosenZip in MapView: \(chosenZip)")
    }
    
    @IBAction func pressedTopFilterBtn(_ sender: Any) {
        print("top button pressed")
        
        if !filterFeatureOn && !filterHoodOn {
            print("park feature filter button pressed!")
            performSegue(withIdentifier: "featureFilterVC", sender: self)
        } else if filterFeatureOn || filterHoodOn {
            print("clear filter button pressed!")
            chosenZip = ""
            chosenHood = ""
            chosenFeature = ""
            viewDidLoad()
        } else {
            print("ERROR- top button pressed but logic fails")
        }
    }
    
   
    @IBAction func pressedBottomFilterBtn(_ sender: Any) {
        print("bottom button pressed")
        
        if !filterFeatureOn && !filterHoodOn {
            print("hood filter button pressed!")
            performSegue(withIdentifier: "hoodFilterVC", sender: self)
        } else if filterFeatureOn {
            print("feature filter button pressed!")
            performSegue(withIdentifier: "featureFilterVC", sender: self)
        } else if filterHoodOn {
            print("hood filter button pressed!")
            performSegue(withIdentifier: "hoodFilterVC", sender: self)
        } else {
            print("ERROR- bottom button pressed but logic fails")
            print("filterFeatureOn: \(filterFeatureOn)")
            print("filterHoodOn: \(filterHoodOn)")
        }
        
    }
    
    @IBAction func pressedBadgesBtn(_ sender: Any) {
        print("user achievements button pressed!")
        performSegue(withIdentifier: "badgesSegue", sender: self)
    }
    
    
    
//PREPARE FOR SEGUE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parkDetails" {
            let destinationViewController = segue.destination as! ParkInfoViewController
            destinationViewController.parkData = passedAnnotation
        }
        
        //segue to UserProgressVC
//        if segue.identifier == "ProgressVCSegue" {
//            let destination = segue.destination as! UserProgressViewController
//            destination.allAnnotationPins = allAnnotationPins as! [AnnotationPin]
//        }
        
        //segue to FiltersViewController
        if segue.identifier == "hoodFilterVC" {
            print("button pressed --> hoodFilterVC")
            let hoodFilterVC: HoodFilterViewController = segue.destination as! HoodFilterViewController
            hoodFilterVC.delegate = self
            //at this time, not sending any data to HoodFilterVC, just the delegate
        }
        
        //NEW segue to UserProgressVC
        if segue.identifier == "badgesSegue" {
            print("button pressed --> UserAchievementsVC")
            let userProgressVC: UserProgressViewController = segue.destination as! UserProgressViewController
            userProgressVC.allAnnotationPins = allAnnotationPins as! [AnnotationPin]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView?.showsUserLocation = true
    }
    
    //BAD SIDE EFFECT OF THIS METHOD: viewDidLoad loads 2x on initial load, so if user goes straight to badges page, there are twice as many parks objects passed.
    //INTENTION OF THIS METHOD: This makes the map refresh when pressing back button from ParkInfoViewController.
    override func viewWillAppear(_ animated: Bool = true) {
        super.viewWillAppear(animated)
        print("In MapViewVC viewWillAppear")
        //mapView?.reloadInputViews()
        viewDidLoad()

    }
    
    //LOGOUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().disconnect()
            print("Disconnecting...handleLogout")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginVC
            
        } catch let logoutError as NSError {
            print ("Error signing out: \(logoutError)")
        }
        //let loginController = SignInViewController()
        //present(loginController, animated: true, completion: nil)
    }
    
    //HELPER FUNCTIONS>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    func BoolToString(b: Bool?)->String {
        return b?.description ?? "<None>"
    }
    
}
