//
//  AppDelegate.swift
//  in.notes
//
//  Created by Michael Babiy on 6/4/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//

import UIKit

let INBootstrappedInitialData: NSString = "kINBootstrappedInitialData"
let INNotesDefaultAppColor: UIColor = UIColor(red:0.44, green:0.51, blue:0.6, alpha:1.0)

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UITextViewDelegate   {
                            
    var window: UIWindow?
    
    func setupAppearance()
    {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = INNotesDefaultAppColor
        
        let attributes: Dictionary = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 20.0),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSUnderlineStyleAttributeName : 3]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back-button-alt")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back-button-alt")
    }
    
    func bootstrapInitialData()
    {
        NSUserDefaults.standardUserDefaults().boolForKey(INBootstrappedInitialData) ? println("Was bootstrapped...") : INPost.bootstrapInitialPostData()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        setupAppearance()
        bootstrapInitialData()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!)
    {
        //
    }
}

