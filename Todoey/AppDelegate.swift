//
//  AppDelegate.swift
//  Todoey
//
//  Created by Satyia Anand on 20/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        

        do{
            _ = try Realm()
           
        }catch{
            print("Error with realm: \(error)")
        }
        
        
        return true
    }



   

}

