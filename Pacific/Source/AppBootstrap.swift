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
public class BasicViewController: UIViewController {
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {
    view.backgroundColor = .whiteColor()
  }
}
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
  
  public func setup() {
    backgroundColor = .whiteColor()
  }
}

public class BasicCell: UITableViewCell {
  
  public var topBorder: UIView?
  public var bottomBorder: UIView?
  
  private var buttonContainer: UIButton?
  
  public var tappedHandler: ((BasicCell) -> Void)?
  public var pressedHandler: ((BasicCell) -> Void)?
  public var pressedExitHandler: ((BasicCell) -> Void)?
  
  public var toggleHandler: ((BasicCell) -> Void)?
  public var isActive: Bool = false
  
  public init() {
    super.init(style: .Default, reuseIdentifier: nil)
    setup()
  }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {
    
    backgroundColor = .whiteColor()
    
    topBorder = UIView()
    topBorder?.backgroundColor = .lightPlaceholderColor()
    topBorder?.hidden = true
    addSubview(topBorder!)
    
    bottomBorder = UIView()
    bottomBorder?.backgroundColor = .lightPlaceholderColor()
    addSubview(bottomBorder!)
    
    buttonContainer = UIButton()
    buttonContainer?.addTarget(self, action: #selector(self.tapped), forControlEvents: .TouchUpInside)
    buttonContainer?.addTarget(self, action: #selector(self.pressed), forControlEvents: .TouchDown)
    buttonContainer?.addTarget(self, action: #selector(self.pressedExit), forControlEvents: .TouchDragExit)
    addSubview(buttonContainer!)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    topBorder?.frame = CGRectMake(0, 0, frame.width, 1)
    bottomBorder?.frame = CGRectMake(0, frame.height - 1, frame.width, 1)
    
    buttonContainer?.frame = CGRectMake(0, 0, frame.width, frame.height)
  }
  
  public func tapped() {
    tappedHandler?(self)
    isActive = !isActive
  }
  
  public func pressed() {
    pressedHandler?(self)
  }
  
  public func pressedExit() {
    pressedExitHandler?(self)
    isActive = !isActive
  }
}
/**************************************************************
 
                      APP BOOTSTRAP EXTENSIONS
 
 ***************************************************************/
extension UIColor {
  
  public class func textColor() -> UIColor {
    return UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
  }
  
  public class func lightPlaceholderColor() -> UIColor {
    return UIColor(red: 225/255, green: 225/255, blue: 220/255, alpha: 1.0)
  }
  
  public class func darkPlaceholderColor() -> UIColor {
    return UIColor(red: 195/255, green: 195/255, blue: 190/255, alpha: 1.0)
  }
}

















