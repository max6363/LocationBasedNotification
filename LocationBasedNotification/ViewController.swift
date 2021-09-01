//
//  ViewController.swift
//  LocationBasedNotification
//
//  Created by minhazpanara on 31/08/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    private let notificationScheduler = NotificationScheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        notificationScheduler.delegate = self
    }
    
    @IBAction func scheduleNotification(_ sender: Any) {
    
        let notification = NotificationData(notificationId: "notification_decathlon_c_g_road_ahmedabad",
                                                        locationId: "location_decathlon_c_g_road_ahmedabad",
                                                        radius: 400,
                                                        latitude: 23.02468644471346,
                                                        longitude: 72.55654434307856,
                                                        title: "Welcome to Decathlon CG Road",
                                                        body: "Tap to see more information",
                                                        data: ["location": "Decathlon CG Road"])
        
        notificationScheduler.requestNotification(with: notification)
    }
}

extension ViewController: NotificationSchedulerDelegate {
    
    func locationPermissionDenied() {
        let message = "The location permission was not authorized. Please enable it in Settings to continue."
        showSettingsAlert(message: message)
    }
    
    func notificationPermissionDenied() {
        let message = "The notification permission was not authorized. Please enable it in Settings to continue."
        showSettingsAlert(message: message)
    }
    
    func notificationScheduled(error: Error?) {
        if let error = error {
            let alertController = UIAlertController(title: "Notification Schedule Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Notification Scheduled!",
                                                    message: "You will be notified when you are near the location!",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "notification_decathlon_c_g_road_ahmedabad" {
            let notificationData = response.notification.request.content.userInfo
            let message = "You have reached \(notificationData["location"] ?? "your location!")"
            
            let alertController = UIAlertController(title: "Welcome!",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
        completionHandler()
    }
    
    private func showSettingsAlert(message: String) {
        let alertController = UIAlertController(title: "Permissions Denied!",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}
