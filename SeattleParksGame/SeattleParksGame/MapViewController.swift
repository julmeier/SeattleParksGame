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
//    let visited: Bool
}


class  MapViewController: UIViewController, MapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
//    var ref: DatabaseReference!
    var dbReference: DatabaseReference?
    var pin: AnnotationPin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate needed for custom pin
        mapView.delegate = self
        
        //set up Firebase database reference variable
        dbReference = Database.database().reference()
        
        let initialLocation = CLLocation(latitude: 47.6074717, longitude: -122.3352511)
        zoomMapOn(location: initialLocation)
        
//        let myPark = ParkAddress(pmaid: "111", name: "Pretend Park", address: "pretend address", zip_code: "98101", x_coord: "42.6075", y_coord: "-122.3353")
//        print(myPark)
//        print("myPark is printed above")

//        let samplePin1 = AnnotationPin(
//            title: "SAMPLE PIN 1",
//            subtitle: "Frogs Legs",
//            coordinate: CLLocationCoordinate2D(latitude: 47.6074717, longitude: -122.3352511)
//        )
//        mapView.addAnnotation(samplePin1)
        
//        let samplePin2 = AnnotationPin(
//            title: "Sample PIN 2",
//            subtitle: "Mac & Cheese",
//            coordinate: CLLocationCoordinate2D(latitude: 47.620586, longitude: -122.302231)
//        )
//        mapView.addAnnotation(samplePin2)
        
        let path = Bundle.main.path(forResource: "SeattleParksAddresses", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            //print(String(data: data, encoding: .utf8)!)
//            let dataString = String(data: data, encoding: .utf8)!
//            print(dataString)
//            print("dataString is above (prints all park)")
            
            let decoder = JSONDecoder()
            let parks = try decoder.decode([ParkAddress].self, from: data)
            for park in parks {
//                print(park.name)
                let long = (park.x_coord as NSString).doubleValue
                let lat = (park.y_coord as NSString).doubleValue
                let aPin = AnnotationPin(
                    title: park.name,
                    subtitle: park.address,
                    coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)
                )
                mapView.addAnnotation(aPin)
                
                //ONLY ONCE AT ACCOUNT CREATION: create and populate initial Firebase database for testUser1:
                //retrieves all pmaids and sets value to false:
                dbReference?.child("users").child("testUser1").child("parkVisits").child(park.pmaid).setValue(false)
                //creates userdata structure only with no data:
                dbReference?.child("users").child("testUser1").child("badges").child(park.zip_code).setValue(false)
                //dbReference?.child("users").child("testUser2").child("badges")
                
                
            }

//            let thisXCoord = park["x_coord"]
//            print("PRINTING X_COORD BELOW")
//            print(thisXCoord)
            
//            pin = AnnotationPin(title: park.name, subtitle: park.address, coordinate: CLLocation(latitude: park.x_coord, longitude: park.y_coord)
            
//            print(parks)
//            print("parks is above")
//            let firstPark = parks[0]
//            print(firstPark.name)
            
        }
        catch {
            print("error try to convert park address data to JSON")
            print(error)
            
        }
        
        
        //Retrieve the firebase data and listen for changes
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor: annotation: MKAnnotation) -> MKAnnotationView? (
        let annotationView = MKAnnotationView(annotation: )
    )
    
    private let regionRadius: CLLocationDistance = 4000 //1km = 1000
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
