//
//  AppHttp.swift
//  boilerplate-ios-app
//
//  Created by Andrew Aquino on 5/31/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias HttpResponseBlock  = (json: JSON?, error: NSError?) -> Void

extension App {
  
  public static func POST(endPoint: String, parameters: [ String: AnyObject ], responseBlock: HttpResponseBlock) {
    Alamofire.request(.POST, App.ServerURL + endPoint, parameters: parameters)
    .response { (req, res, data, error) in
      if let error = error {
        log.error(error)
        responseBlock(json: nil, error: error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        responseBlock(json: json, error: nil)
      }
    }
  }
  
  public static func GET(endPoint: String, parameters: [ String: AnyObject ]? = nil, responseBlock: HttpResponseBlock) {
    Alamofire.request(.GET, App.ServerURL + endPoint, parameters: parameters)
    .response { (req, res, data, error) in
      if let error = error {
        log.error(error)
        responseBlock(json: nil, error: error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        responseBlock(json: json, error: nil)
      }
    }
  }
}