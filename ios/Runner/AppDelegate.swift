import UIKit
import Flutter
import flutter_local_notifications
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

        FirebaseApp.configure()
      UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
          ) { granted, _ in
            print("Permission granted: \(granted)")
          }
          

          
          // Register for remote notifications
          application.registerForRemoteNotifications()
      
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)}

        GeneratedPluginRegistrant.register(with: self)

          if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
