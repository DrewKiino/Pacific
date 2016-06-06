//
//  NativeExtensions.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/4/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Async
import SwiftDate
import SDWebImage
import Tide

extension UIColor {
  
  class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
    var rgb: CUnsignedInt = 0;
    let scanner = NSScanner(string: hex)
    scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
    scanner.scanHexInt(&rgb)
    return UIColor(
      red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
      blue: CGFloat(rgb & 0xFF) / 255.0,
      alpha: alpha
    )
  }
}

extension Int {
  
  public func toFormattedPhoneNumberText() -> NSMutableString {
    let string: NSMutableString = NSMutableString(string: String(self))
    if string.length == 11 {
      string.insertString("-", atIndex: 1)
      string.insertString("-", atIndex: 5)
      string.insertString("-", atIndex: 9)
    } else if string.length == 10 {
      string.insertString("-", atIndex: 3)
      string.insertString("-", atIndex: 7)
    } else if string.length == 7 {
      string.insertString("-", atIndex: 3)
    }
    return string
  }
}

extension UIFont {
  
  // EXAMPLE TO REFERENCE CUSTOM FOLT
//  public class func asapBold(size: CGFloat) -> UIFont {
//    return UIFont(name: "Asap-Bold", size: size)!
//  }
}

extension String {
  
  public func isRecent() -> Bool {
    return 60.seconds.ago < toDateFromISO8601()
  }
  
  public func convertToOrdinal() -> String {
    if  let last = characters.last where Int(String(last)) != nil && self.lowercaseString.rangeOfString("edition") == nil {
      if last == "1" {
        return "\(self)st"
      } else if last == "2" {
        return "\(self)nd"
      } else if last == "3" {
        return "\(self)rd"
      } else {
        return "\(self)th"
      }
    }
    return self
  }
  
  public func substringWithRange(start: Int, length: Int) -> String {
    return NSString(string: self).substringWithRange(NSRange(location: start, length: length))
  }
}

extension NSMutableAttributedString {
  
  func height(width: CGFloat) -> CGFloat {
    return boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil ).height
  }
  
  func append(attributedString: NSMutableAttributedString?) -> Self {
    if let attributedString = attributedString {
      appendAttributedString(attributedString)
    }
    return self
  }
  
  func setColor(color: UIColor) -> Self {
    addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, string.characters.count - 1))
    return self
  }
}

extension UIViewController {
  
  public enum UIType {
    case LeftBarButton
    case RightBarButton
  }
  
  public func showAlert(title: String?, message: String?, completionBlock: (() -> Void)? = nil) {
    var alertController: UIAlertController! = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel) { action in
      completionBlock?()
      })
    presentViewController(alertController, animated: true, completion: nil)
    alertController = nil
  }
  
  public func showActivity(uiType: UIType) {
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    activityIndicator.startAnimating()
    switch uiType {
    case .LeftBarButton:
      navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
      break
    case .RightBarButton:
      navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
      break
    }
    activityIndicator = nil
  }
  
  public func hideActivity(uiType: UIType) {
    switch uiType {
    case .LeftBarButton:
      navigationItem.leftBarButtonItem = nil
      break
    case .RightBarButton:
      navigationItem.rightBarButtonItem = nil
      break
    }
  }
  
  public func setButton(uiType: UIType, title: String, target: AnyObject?, selector: Selector) {
    switch uiType {
    case .LeftBarButton:
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .Plain, target: target, action: selector)
      break
    case .RightBarButton:
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .Plain, target: target, action: selector)
      break
    }
  }
  
  public func hideButton(uiType: UIType) {
    switch uiType {
    case .LeftBarButton:
      navigationItem.leftBarButtonItem = nil
      break
    case .RightBarButton:
      navigationItem.rightBarButtonItem = nil
      break
    }
  }
}


extension String {
  
  public func height(width: CGFloat, font: UIFont = UIFont.systemFontOfSize(12)) -> CGFloat{
    let height = self.boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options:
      NSStringDrawingOptions.UsesLineFragmentOrigin,
      attributes: [
        NSFontAttributeName: font
      ],
      context: nil
      ).height
    return (height * 1.12) + (self.width(height) > width - 128 ? 24 : 0)
    // WHY add a modifier? because at large texts, textview height will always return the height minus some lines
    // for some reason, so we compensate by adding the height of line which justly estimates around this number
  }
  
  public func width(height: CGFloat, font: UIFont = UIFont.systemFontOfSize(12)) -> CGFloat {
    let width = self.boundingRectWithSize(CGSize(width: CGFloat.max, height: height), options:
      NSStringDrawingOptions.UsesLineFragmentOrigin,
      attributes: [
        NSFontAttributeName: font
      ],
      context: nil
      ).width
    return width
    // WHY add a modifier? because at large texts, textview height will always return the height minus some lines
    // for some reason, so we compensate by adding the height of line which justly estimates around this number
  }
}

extension UIView {
  
  public func showActivityView(heightOffset: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil, style: UIActivityIndicatorViewStyle = .Gray) {
    dismissActivityView()
    var activityView: UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle: style)
    activityView.frame = CGRectMake(0, heightOffset ?? 0, width ?? frame.width, height ?? frame.height)
    activityView.tag = 1337
    activityView.startAnimating()
    addSubview(activityView)
    activityView = nil
  }
  
  public func dismissActivityView() {
    for view in subviews {
      if let activityView = view as? UIActivityIndicatorView where activityView.tag == 1337 {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
      }
    }
  }
}

extension NSAttributedString {
  
  func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.max)
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: CGFloat.max, height: height)
    
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.width)
  }
}
