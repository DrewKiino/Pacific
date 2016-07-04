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
  public static var globalModifier: CGFloat = 1.0
/**************************************************************
 
                        FONTS
 
 ***************************************************************/
  // Ultralight, Light, Medium, Semibold, and Bold.
  public static var fontSize: CGFloat = UIFont.systemFontSize()
  
  public static var fontSizeModifier: CGFloat = 1.0
  
  public enum Font {
    case One
    case Two
  }
  
  public static func systemFont(size: CGFloat = fontSize) -> UIFont {
    return UIFont.systemFontOfSize(size * App.fontSizeModifier)
  }
  public static func systemBoldFont(size: CGFloat = fontSize) -> UIFont {
    return UIFont.boldSystemFontOfSize(size * App.fontSizeModifier)
  }
  
  public static let ultralightFontNames: [String] = []
  public static func ultralightFont(font: Font = Font.One, size: CGFloat = fontSize) -> UIFont? {
    if ultralightFontNames.isEmpty { return nil }
    return UIFont(name: ultralightFontNames[font.hashValue], size: size * App.fontSizeModifier)
  }
  
  public static var lightFontNames: [String] = []
  public static func lightFont(font: Font = Font.One, size: CGFloat = fontSize) -> UIFont? {
    if lightFontNames.isEmpty { return nil }
    return UIFont(name: lightFontNames[font.hashValue], size: size * App.fontSizeModifier)
  }
  
  public static var mediumFontNames: [String] = []
  
  public static func mediumFont(font: Font = Font.One, size: CGFloat = fontSize) -> UIFont? {
    if mediumFontNames.isEmpty { return nil }
    return UIFont(name: mediumFontNames[font.hashValue], size: size * App.fontSizeModifier)
  }
  
  public static var semiBoldFontNames: [String] = []
  
  public static func semiBoldFont(font: Font = Font.One, size: CGFloat = fontSize) -> UIFont? {
    if semiBoldFontNames.isEmpty { return nil }
    return UIFont(name: semiBoldFontNames[font.hashValue], size: size * App.fontSizeModifier)
  }
  
  public static var boldFontnames: [String] = []
  
  public static func boldFont(font: Font = Font.One, size: CGFloat = fontSize) -> UIFont? {
    if semiBoldFontNames.isEmpty { return nil }
    return UIFont(name: boldFontnames[font.hashValue], size: size * App.fontSizeModifier)
  }
  /**************************************************************
   
                      COLORS
   
   ***************************************************************/
  public static func textColor() -> UIColor {
    return UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
  }
  
  public static func lightPlaceholderColor() -> UIColor {
    return UIColor(red: 225/255, green: 225/255, blue: 220/255, alpha: 1.0)
  }
  
  public static func darkPlaceholderColor() -> UIColor {
    return UIColor(red: 195/255, green: 195/255, blue: 190/255, alpha: 1.0)
  }
/**************************************************************
 
                        APP BOOTSTRAP CLASS
 
 ***************************************************************/
  public static func currentDevice() -> UIUserInterfaceIdiom {
    return UIDevice.currentDevice().userInterfaceIdiom
  }
  
  public static func iPhoneOnly<T>(handler: (() -> T)) -> T? {
    if currentDevice() == .Phone { return handler() }
    else { return nil }
  }
  
  public static func iPadOnly<T>(handler: (() -> T)) -> T? {
    if currentDevice() == .Pad { return handler() }
    else { return nil }
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
    topBorder?.backgroundColor = App.lightPlaceholderColor()
    topBorder?.hidden = true
    addSubview(topBorder!)
    
    bottomBorder = UIView()
    bottomBorder?.backgroundColor = App.lightPlaceholderColor()
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
















