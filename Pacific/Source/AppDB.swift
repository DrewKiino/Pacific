//
//  AppDB.swift
//  FoodTruckieLA
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Pantry
import Async

extension App {
  
  private static func _write<T: StorableDefaultType>(object: T?, key: String) -> T? {
    if let object = object {
      Pantry.pack(object, key: key)
      return object
    } else {
      return nil
    }
  }
  
  private static func _read<T: StorableDefaultType>(key: String) -> T? {
    return Pantry.unpack(key)
  }
  
  private static func _delete<T: StorableDefaultType>(key: String) -> T? {
    if let object = App._read("Test") as T! {
      Pantry.expire(key)
      return object
    } else {
      return nil
    }
  }
  
  public static func write(string: String?, key: String) -> String? {
    return _write(string, key: key)
  }
  
  public static func read(key: String) -> String? {
    return _read(key)
  }
  
  public static func delete(key: String) -> String? {
    return _delete(key)
  }
}