//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/01/30.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var BG_NAME_PROCESSING_TASK = "com.youngho02.Tracker.processing"
    var BG_NAME_REPRESH_TASK = "com.youngho02.Tracker.refresh"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        registerBackgroundTask()
//        registerLocalNotification()
        
        dump("app is started!!!")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        dump("22222")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

        dump("33333")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        dump("44444")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        dump("55555")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        dump("enter in applicationDidEnterBackground")
        
        cancelAllPandingBGTask()
        scheduleAppRefresh()
        scheduleGPSUpdater()
        QueryService().send(searchTerm: "abcdefg")
    }
    
    //MARK: Regiater BackGround Tasks
    func registerBackgroundTask() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BG_NAME_REPRESH_TASK, using: nil) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BG_NAME_PROCESSING_TASK, using: nil) { task in
            self.handleGPSUpdaterTask(task: task as! BGProcessingTask)
        }
    }
}
    
//MARK:- BGTask Helper
extension SceneDelegate {
    
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    func scheduleGPSUpdater() {
        
        let request = BGProcessingTaskRequest(identifier: BG_NAME_PROCESSING_TASK)
        request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Featch Image Count after 1 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule image featch: \(error)")
        }
    }
    
    func scheduleAppRefresh() {
        
        let request = BGAppRefreshTaskRequest(identifier: BG_NAME_REPRESH_TASK)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // App Refresh after 1 minute.
    
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        /*
         //AppRefresh Process
         */
        print("2222222")
        
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }

//        scheduleLocalNotification()
        
        task.setTaskCompleted(success: true)
        
        scheduleAppRefresh()
    }
    
    func handleGPSUpdaterTask(task: BGProcessingTask) {
        
        print("1111111111")
        
        //Todo Work
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
        
        task.setTaskCompleted(success: true)
        
        scheduleGPSUpdater() // Recall
    }
}

//MARK:- Notification Helper
extension SceneDelegate {
    
    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
    }
    
    func fireNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Bg"
        notificationContent.body = "BG Notifications."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}
