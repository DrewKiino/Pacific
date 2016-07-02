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
import AssetsLibrary

public typealias HttpResponseBlock  = (json: JSON?, error: NSError?) -> Void

extension App {
  
  public static func UPLOAD(endpoint: String, data: NSData?, filename: String? = nil, key: String?, progress: (Float -> Void)? = nil, completionHandler: HttpResponseBlock) {
    if let data = data, let key = key {
      Alamofire.upload(
        .POST,
        App.ServerURL + endpoint,
        headers: [
          "key": key
        ] as [ String: String ],
        multipartFormData: { multipartFormData in
          multipartFormData.appendBodyPart(data: data, name: "file")
        },
        encodingCompletion: { encodingResult in
          switch encodingResult {
          case .Success(let upload, _, _):
            upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
              dispatch_async(dispatch_get_main_queue(), {
                /**
                 *  Update UI Thread about the progress
                 */
                progress?(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
              })
            }
            upload.response { req, res, data, error in
              if let error = error {
                log.error(error)
                completionHandler(json: nil, error: error)
              } else if let data = data {
                completionHandler(json: JSON(data: data), error: nil)
              }
            }
          case .Failure(let error):
            log.error(error)
            completionHandler(json: nil, error: nil)
            //Show Alert in UI
          }
        }
      )
    }
  }
  
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