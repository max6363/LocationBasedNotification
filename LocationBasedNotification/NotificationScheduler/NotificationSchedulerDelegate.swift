//
//  NotificationSchedulerDelegate.swift
//  LocationBasedNotification
//
//  Created by minhazpanara on 31/08/21.
//

import UserNotifications

protocol NotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    /// callback when user denied for the notification permission
    func notificationPermissionDenied()
    
    /// callback when user denied for the location perission
    func locationPermissionDenied()
    
    /// callback notification has been scheduled or return with error object
    ///
    /// - Parameter error: error when trying to add the notification.
    func notificationScheduled(error: Error?)
}
