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
  public static var serverURL: String = ""
/**************************************************************

                        SCREEN SIZE

***************************************************************/
  public static var screen = UIScreen.mainScreen().bounds
/**************************************************************

                        ENV VARS

***************************************************************/
  public static var isProduction: Bool = false
/**************************************************************
 
                        FONTS
 
 ***************************************************************/
  // Ultralight, Light, Medium, Semibold, and Bold.
  public static var fontSize: CGFloat = UIFont.systemFontSize()
  public static var fontSizeModifier: CGFloat = 1.0
  public func font(size: CGFloat = fontSize) -> UIFont {
    return UIFont.systemFontOfSize(size * App.fontSizeModifier)
  }
  public static var ultralightFontName: String = ""
  public static func ultralightFont(size: CGFloat = fontSize) -> UIFont? {
    return UIFont(name: ultralightFontName, size: size * App.fontSizeModifier)
  }
  public static var lightFontName: String = ""
  public static func lightFont(size: CGFloat = fontSize) -> UIFont? {
    return UIFont(name: lightFontName, size: size * App.fontSizeModifier)
  }
  public static var mediumFontName: String = ""
  public static func mediumFont(size: CGFloat = fontSize) -> UIFont? {
    return UIFont(name: mediumFontName, size: size * App.fontSizeModifier)
  }
  public static var semiBoldFontName: String = ""
  public static func semiBoldFont(size: CGFloat = fontSize) -> UIFont? {
    return UIFont(name: semiBoldFontName, size: size * App.fontSizeModifier)
  }
  public static var boldFontname: String = ""
  public static func boldFont(size: CGFloat = fontSize) -> UIFont {
    return UIFont(name: boldFontname, size: size * App.fontSizeModifier) ?? UIFont.boldSystemFontOfSize(size * App.fontSizeModifier)
  }
/**************************************************************
 
                        APP BOOTSTRAP CLASS
 
 ***************************************************************/
  public static func currentDevice() -> UIUserInterfaceIdiom {
    return UIDevice.currentDevice().userInterfaceIdiom
  }
  
  public static func iPhoneOnly(handler: (() -> Void)) {
    if currentDevice() == .Phone { handler() }
  }
  
  public static func iPadOnly(handler: (() -> Void)) {
    if currentDevice() == .Pad { handler() }
  }
  
  public static func start( inout window window: UIWindow?, rootView: UIViewController?) {
    
    // set logging config
    Atlantis.Configuration.hasColoredLogs = true
    
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

















