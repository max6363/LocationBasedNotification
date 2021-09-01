//
//  NotificationData.swift
//  LocationBasedNotification
//
//  Created by minhazpanara on 31/08/21.
//

import CoreLocation

struct NotificationData {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
