//
//  AppBootstrap.swift
//  boilerplate-ios-app
//
//  Created by Andrew Aquino on 5/31/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Atlantis
import UIColor_Hex_Swift
import SwiftyTimer
import Neon

/**************************************************************

                        LOGGING LIBRARY

***************************************************************/
public let log = Atlantis.Logger()
/**************************************************************

                        GLOBAL VARS

***************************************************************/
public struct App {
/**************************************************************

                        SERVER URL

***************************************************************/
  public static let ServerURL: String! = AppBootstrap.Singleton.ServerURL
/**************************************************************

                        SCREEN SIZE

***************************************************************/
  public static let Screen = UIScreen.mainScreen().bounds
/**************************************************************

                        ENV VARS

***************************************************************/
  public static var isProduction: Bool = false
}
/**************************************************************
 
                        APP BOOTSTRAP CLASS
 
 ***************************************************************/
public class AppBootstrap {
  
  private struct Singleton {
    private static var ServerURL: String?
  }
  
  public class func start(
    inout window window: UIWindow?,
    rootView: UIViewController?,
    serverUrl: String,
    isProduction: Bool = false
  ) {
    
    // set logging config
    Atlantis.Configuration.hasColoredLogs = true
    
    Singleton.ServerURL = serverUrl
    
    App.isProduction = isProduction
    
    if let rootView = rootView {
      // config rootview
      rootView.view.backgroundColor = .whiteColor()
      // set the window to match the screen's bounds
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
      window?.rootViewController = rootView
      // commit change
      window?.makeKeyAndVisible()
    }
    
    // connect with sockets
    Socket.sharedInstance().connect()
  }
}

