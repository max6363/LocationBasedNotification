//
//  NotificationScheduler.swift
//  LocationBasedNotification
//
//  Created by minhazpanara on 31/08/21.
//

import Foundation

import CoreLocation
import UserNotifications

class NotificationScheduler: NSObject {
    
    // MARK: - Public Properties
    
    weak var delegate: NotificationSchedulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Public Functions
    
    /// Request a location notification with data.
    func requestNotification(with notificationInfo: NotificationData) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .authorizedWhenInUse, .authorizedAlways:
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .restricted, .denied:
            delegate?.locationPermissionDenied()
            break
        }
    }
}

// MARK: - Private Functions

private extension NotificationScheduler {
    
    func askForNotificationPermissions(notificationInfo: NotificationData) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    DispatchQueue.main.async {
                        self?.delegate?.notificationPermissionDenied()
                    }
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: NotificationData) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let destRegion = destinationRegion(notificationInfo: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId,
                                            content: notification,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.delegate?.notificationScheduled(error: error)
            }
        }
    }
    
    func notificationContent(notificationInfo: NotificationData) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
    
    func destinationRegion(notificationInfo: NotificationData) -> CLCircularRegion {
        let destRegion = CLCircularRegion(center: notificationInfo.coordinates,
                                          radius: notificationInfo.radius,
                                          identifier: notificationInfo.locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        return destRegion
    }
}
