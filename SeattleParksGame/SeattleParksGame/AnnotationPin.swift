//
//  AnnotationPin.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/4/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var visitStatusInPin: Bool?
    var imageName: String?
    
    init(title: String, subtitle: String?, coordinate: CLLocationCoordinate2D, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.imageName = imageName
        
        super.init()
    }
}
