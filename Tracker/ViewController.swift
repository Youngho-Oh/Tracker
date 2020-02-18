//
//  ViewController.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/01/30.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreLocation

// [START viewcontroller_interfaces]
class ViewController: UIViewController , CLLocationManagerDelegate {
// [END viewcontroller_interfaces]
    
    // [START viewcontroller_vars]
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    // [END viewcontroller_vars]
    
    /* values For GPS */
    var locationManager : CLLocationManager = CLLocationManager()
    var startLocation : CLLocation!

    @IBAction func resetDistance(_ sender: AnyObject){
        startLocation = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START_EXCLUDE]
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveToggleauthUINotification(_:)), name: NSNotification.Name(rawValue: "ToggleAuthUINotification"), object: nil)
        
        statusText.text = "Initialized Swift app..."
        toggleAuthUI()
        // [END_EXCLUDE]
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        dump("GPSViewController is Done to load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dump(String(format: "%d", locations.count))
        let latestLocation : CLLocation = locations[locations.count-1]
        let latitude : Double = latestLocation.coordinate.latitude
        let longitude : Double = latestLocation.coordinate.longitude
        let altitude : Double = latestLocation.altitude
        
        if startLocation == nil {
            dump("startLocation is nuil")
            startLocation = latestLocation
        }
        let distanceBetween : CLLocationDistance = latestLocation.distance(from: startLocation)
        
        dump("=================================")
        dump(String(format: "latitude : %.4f", latitude))
        dump(String(format: "longitude : %.4f", longitude))
        dump(String(format: "altitude : %.4f", altitude))
        dump(String(format: "distanceBetween : %.2f", distanceBetween))
        dump("=================================")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump("error : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        dump("Change authority policy is changed")
        switch status {
        case CLAuthorizationStatus.authorizedAlways:
            dump("Always")
        case CLAuthorizationStatus.authorizedWhenInUse:
            dump("WhenInUse")
        case CLAuthorizationStatus.notDetermined:
            dump("notDetermined")
        case CLAuthorizationStatus.restricted:
            dump("restricted")
        default:
            dump("else")
        }
    }
    
    // [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance()?.signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(_ sender:AnyObject) {
        GIDSignIn.sharedInstance()?.disconnect()
        // [START_EXCLUDE silent]
        statusText.text = "Disconnecting."
        // [END_EXCLUDE silent]
    }
    
    // [START toogle_auth]
    func toggleAuthUI(){
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            //Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in/niOS Demo"
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ToggleAuthUINotification"), object: nil)
    }
    
    @objc func receiveToggleauthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.statusText.text = userInfo["statusText"]!
            }
        }
    }
}
