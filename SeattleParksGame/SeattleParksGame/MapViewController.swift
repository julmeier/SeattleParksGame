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
import FirebaseDatabase


class  MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
//    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 47.6074717, longitude: -122.3352511)
        zoomMapOn(location: initialLocation)
        
        //set firebase reference
//        ref = FIRDatabase.database().reference()
        
        //Retrieve the posts and listen for changes
        
    }
    
    private let regionRadius: CLLocationDistance = 1000 //1km
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 4.0, regionRadius * 4.0)
        mapView.setRegion(coordinateRegion, animated:true)
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
