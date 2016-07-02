//
//  Example.swift
//  Pacific
//
//  Created by Andrew Aquino on 7/1/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation

public class Example {
  
  public func test() {
    
    
    App.POST("/user/findOne", parameters: [ "_id": "12345" ]) { [weak self] json, error in
      
      let name = json?["name"].string
      let age = json?["age"].int
      
      let user = User(name: name, age: age)
      
      self?.setAsDefaultUser(user)
    }
    
    
  }
  
  
  public func setAsDefaultUser(user: User) {
    
  }
}

public class User {
  init(name: String?, age: Int?) {
    
  }
}
