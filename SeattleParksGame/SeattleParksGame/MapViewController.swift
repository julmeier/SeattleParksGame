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

struct ParkAddress: Codable {
    let pmaid: String
    let name: String
    let address: String
    let zip_code: String
    let x_coord: String
    let y_coord: String
}

class  MapViewController: UIViewController, MKMapViewDelegate {

    //Mapping variables:
    @IBOutlet weak var mapView: MKMapView!
    var purpleTree: AnnotationPin!
    var greenTree: AnnotationPin!
    var pin: AnnotationPin!
    
    //Firebase database references:
    var dbReference: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    
    //variable to hold annotation when it's passed to ParkInfoViewController
    var passedAnnotation: AnnotationPin?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate needed for custom pin
        self.mapView.delegate = self
        
        //this doesn't seem to be working:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        
        let initialLocation = CLLocation(latitude: 47.6074717, longitude: -122.3352511)
        zoomMapOn(location: initialLocation)
        
        self.mapView.removeAnnotations(mapView.annotations)
        
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
        
        //retrieving JSON data from API directly:
        let seattleParksAddressesUrl = "https://data.seattle.gov/resource/ajyh-m2d3.json"
        guard let url = URL(string: seattleParksAddressesUrl) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            
            guard let data = data else {return}
            print("Printing park data:")
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let parks = try decoder.decode([ParkAddress].self, from: data)
        

                for park in parks {
                    
                    //print("Park name is: \(park.name)")
                    let long = (park.x_coord as NSString).doubleValue
                    let lat = (park.y_coord as NSString).doubleValue
                    
                    //read in data from database to see if the park has been visited
                    
                    self.dbReference?.child("users/testUser1/parkVisits").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(park.pmaid) {
                            //print("pmaid in the db:")
                            //print(park.pmaid)
                            self.greenTree = AnnotationPin(
                                title: park.name,
                                subtitle: "true",
                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                imageName: "green-cloud-tree-32.png",
                                pmaid: park.pmaid,
                                address: park.address
                            )
                            self.mapView.addAnnotation(self.greenTree)
                        } else {
                            //print("pmaid NOT in the db:")
                           // print(park.pmaid)
                            self.purpleTree = AnnotationPin(
                                title: park.name,
                                subtitle: "false",
                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                imageName: "purple-cloud-tree-32.png",
                                pmaid: park.pmaid,
                                address: park.address
                            )
                            self.mapView.addAnnotation(self.purpleTree)
                        } //end of else
                    }) //end of dbReference?.child
                } //end of for park in parks
            
        } //end of do
        catch {
            print("error try to convert park address data to JSON")
            print(error)
        } //end of catch
        print("FINISHED viewDidLoad")
        
    }.resume()
    }
    

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
    
    func BoolToString(b: Bool?)->String { return b?.description ?? "<None>"}
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("button tapped")
        
        //get the annotation, which is a parameter
        //ex from tutorial: b = view.annotation as! book
        passedAnnotation = view.annotation as? AnnotationPin
        print("passedAnnotation in MapView:")
        print(passedAnnotation!)
        print(passedAnnotation?.title! as Any)
        print(passedAnnotation?.address! as Any)
        
        //perform manual segue
        performSegue(withIdentifier: "parkDetails", sender: self)
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
    }
    
    private let regionRadius: CLLocationDistance = 4000 //1km = 1000

    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parkDetails" {
            let destinationViewController = segue.destination as! ParkInfoViewController
            
            //Pass individual parameters to ParkInfoViewController:
//            destinationViewController.name = passedAnnotation?.title!
//            destinationViewController.address = passedAnnotation?.address!
//            destinationViewController.pmaid = passedAnnotation?.pmaid!
//            destinationViewController.visited = passedAnnotation?.subtitle
            
            //OR Pass whole object!
            destinationViewController.parkData = passedAnnotation
        }
    }
    
    //This **SHOULD** make map refresh when pressing back button from ParkInfoViewController....but it doesn't
    override func viewWillAppear(_ animated: Bool = true) {
        super.viewWillAppear(animated)
        //mapView.reloadInputViews()
        self.viewDidLoad()
        
        //mapView.addAnnotations(<#T##annotations: [MKAnnotation]##[MKAnnotation]#>)
        
    }
    
}
