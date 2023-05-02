//
//  Location.swift
//  ToDoTDD
//
//  Created by Bikram Aryal on 02/05/2023.
//

import Foundation
import CoreLocation


struct Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        
        if lhs.coordinate == nil, rhs.coordinate != nil {
            return false
        }
        
        if lhs.coordinate != nil, rhs.coordinate == nil {
            return false
        }
        
        if let lhsCoordinate = lhs.coordinate, let rhsCoordinate = rhs.coordinate {
            if abs(lhsCoordinate.longitude - rhsCoordinate.longitude) > 0.000_000_1 {
                return false
            }
            
            if abs(lhsCoordinate.latitude - rhsCoordinate.latitude) > 0.000_000_1 {
                return false
            }
        }
        return true
    }
    
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}