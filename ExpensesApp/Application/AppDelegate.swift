//
//  AppDelegate.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 5/31/22.
//

import UIKit
import CoreData
import FirebaseMessaging
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator : AppCoordinator?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        NetworkReachability.shared.startNetworkMonitoring()
        startApp()
        setUpIQKeyBoard()
        
        if !AppSettings.isLuanchedBefore{
            addDumyFirstLuanch()
        }
        return true
    }
    
    func addDumyFirstLuanch(){
        AppSettings.isLuanchedBefore = true
        
        for selectedTag in TransactionTagEnum.allCases {
            for selectedType in TransactionTypeEnum.allCases {
                let randomDouble = Double.random(in: 0.0..<100.0)
                CoreDataExpensesHelper.shared.addNewExpenseData(selectedType: selectedType, title: "\(selectedTag) $\(String(format: "%.2f", randomDouble))", tag: selectedTag, occuredOn: Date(), note: "note", amount: randomDouble)

            }
        }
    }
    
    func startApp() {
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }
    
    private func setUpIQKeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    
    // MARK: - Core Data stack
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ExpensesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

