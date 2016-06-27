//
//  AppBootstrap.swift
//  boilerplate-ios-app
//
//  Created by Andrew Aquino on 5/31/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Atlantis

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
  public static let ServerURL: String! = App.Singleton.ServerURL
/**************************************************************

                        SCREEN SIZE

***************************************************************/
  public static let Screen = UIScreen.mainScreen().bounds
/**************************************************************

                        ENV VARS

***************************************************************/
  public static var isProduction: Bool = false
/**************************************************************
 
                        APP BOOTSTRAP CLASS
 
 ***************************************************************/
  
  private struct Singleton {
    private static var ServerURL: String?
  }
  
  public static func start(
    inout window window: UIWindow?,
    rootView: UIViewController?,
    serverUrl: String = "",
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
/**************************************************************
 
                      APP BOOTSTRAP SUBCLASSES
 
 ***************************************************************/
public class BasicView: UIView {
  
  public init() {
    super.init(frame: CGRectZero)
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {}
}
