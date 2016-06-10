//
//  AppDB.swift
//  FoodTruckieLA
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Pantry

extension App {
  
  public static func write<T: StorableDefaultType>(object: T?, key: String) -> T? {
    if let object = object {
      Pantry.pack(object, key: key)
      return object
    } else {
      return nil
    }
  }
  
  public static func read<T: StorableDefaultType>(key: String) -> T? {
    return Pantry.unpack(key)
  }
  
  public static func delete<T: StorableDefaultType>(key: String) -> T? {
    if let object = App.read("Test") as T! {
      Pantry.expire(key)
      return object
    } else {
      return nil
    }
  }
  
  public static func writeString(string: String?, key: String) -> String? {
    return write(string, key: key)
  }
  
  public static func readString(key: String) -> String? {
    return read(key)
  }
  
  public static func deleteString(key: String) -> String? {
    return delete(key)
  }
}