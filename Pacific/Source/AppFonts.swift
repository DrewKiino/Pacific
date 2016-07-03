//
//  AppFonts.swift
//  Pacific
//
//  Created by Andrew Aquino on 7/3/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

extension App {
  
  public static func font(size: CGFloat = fontSize) -> UIFont {
    return UIFont.systemFontOfSize(size)
  }
  
  public static func boldFont(size: CGFloat = fontSize) -> UIFont {
    return UIFont.boldSystemFontOfSize(size)
  }
}