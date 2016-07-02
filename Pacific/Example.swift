//
//  Example.swift
//  Pacific
//
//  Created by Andrew Aquino on 7/1/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

public class Example {
  
  public func test() {
    
    
    // returns a jsonified response from the server
    App.on("Server.Message") { [weak self] json in
      log.debug(json)
      
      let message = json["message"].string
      
      self?.appendMessageToTableView(message)
    }
    
    // emit strings
    App.emit("iOS.Message", object: "Hello, World!")
    
    // emit json objets
    App.emit("iOS.Parcel", objects: [
      "name": "Steven",
      "age": 27,
      "title": "iOS Developer",
      ] as [ String: AnyObject] )
    
    
    App.POST("/user/findOne", parameters: [ "_id": "12345" ]) { [weak self] json, error in
      
      let name = json?["name"].string
      let age = json?["age"].int
      
      let user = User(name: name, age: age)
      
      self?.setAsDefaultUser(user)
    }
    
    
    // CREATE/UPDATE
    App.write("Hamster", key: "password")
    
    // READ
    if let password = App.read("password") as String? {
      // do something with password if it exists in database
      log.debug(password)
    }
    
    // DELETE
    if let deletedPassword = App.delete("password") as String? {
      // deletes and returns the value
      log.warning(deletedPassword)
    }
  }
  
  
  public func setAsDefaultUser(user: User) {}
  public func appendMessageToTableView(message: String?) {}
}

public class User { init(name: String?, age: Int?) {} }
