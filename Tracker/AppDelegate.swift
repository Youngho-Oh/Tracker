//
//  AppDelegate.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/01/30.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //Initialize sign-in
        GIDSignIn.sharedInstance()?.clientID = "gcloud"
//        GIDSignIn.sharedInstance().clientID = "204238408245-vo45lptis8pu7321ft79770bs8jm3hjs.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().clientID = "com.googleusercontent.apps.204238408245-vo45lptis8pu7321ft79770bs8jm3hjs"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // [START openurl]
    func application(_ application: UIApplication,
                      open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        dump("************************************")
//        dump(GIDSignIn.sharedInstance().handle(url))
        return GIDSignIn.sharedInstance().handle(url)
    }
    // [END openurl]
    
    // [START openurl_new]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    // [END openurl_new]
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
            dump( (error as NSError).userInfo )
            dump( (error as NSError).domain )
            dump( (error as NSError).code )
        } else {
          print("\(error.localizedDescription)")
        }
        // [START_EXCLUDE silent]
        NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        // [END_EXCLUDE]
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
      // [START_EXCLUDE]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
      // [END_EXCLUDE]
    }
    
   // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // [START_EXCLUDE]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "User has disconnected."])
//       [END_EXCLUDE]
    }
    // [END disconnect_handler]
}
