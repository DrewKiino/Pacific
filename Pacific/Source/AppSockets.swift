//
//  AppSocket.swift
//  boilerplate-ios-app
//
//  Created by Andrew Aquino on 5/31/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import SocketIOClientSwift
import SwiftyJSON

public typealias SocketResponseBlock  = (json: JSON) -> Void

public class Socket: NSObject, NSURLSessionDelegate {
  
  private struct Singleton {
    static let socket = Socket()
    static var _sessionCount = 0
    static var sessionCount: Int { get { return _sessionCount++ } }
  }
  
  public class func sharedInstance() -> Socket { return Singleton.socket }
  public class func getSessionCount() -> Int { return Singleton.sessionCount }
  
  // MARK: Socket Functions
  
  public var socket_id: Int = 0
  public var session_id: String? = nil
  public var socket = Socket.createNewSocket()
  public var isCurrentlyInChat: Bool = false
  
  public var connectExecutionArray: [String: () -> Void]?
  public var reconnectExecutionArray: [String: () -> Void]?
  
  private var disconnectHandler: (() -> Void)? = nil
  
  public convenience init(room: String?) {
    self.init()
    if let room = room {
      socket = Socket.createNewSocket([
        "room": room
      ])
    }
  }
  
  public func connect(execute: (() -> Void)? = nil) {
    if App.serverURL.isEmpty { return }
    // reset all handlers
    socket.removeAllHandlers()
    // subscribe to default streams
    socket.on("error") { data, socket in
      log.error(data)
    }
    socket.on("connect") { [weak self] data, socket in
      log.info("connection established.")
      
      if let sid = self?.socket.sid {
        log.info("session id: \(sid)")
        self?.session_id = sid
      } else {
        log.warning("unable to retrieve session id")
      }
      
      execute?()
      
      if let executions = self?.connectExecutionArray?.values {
        for execute in executions {
          execute()
        }
      }
    }
    socket.on("reconnect") { data, socket in
    }
    socket.on("reconnectAttempt") { [weak self] data, socket in
      log.info("attempting to reconnect.")
      if let executions = self?.reconnectExecutionArray?.values {
        for execute in executions {
          execute()
        }
      }
    }
    socket.on("disconnect") { [weak self] data, socket in
      log.info("disconnected from server.")
      self?.socket.removeAllHandlers()
      self?.disconnectHandler?()
      self?.disconnectHandler = nil
    }
    socket.connect()
  }
  
  public class func createNewSocket(connectParams: [String :AnyObject]? = nil) -> SocketIOClient {
    let socket = SocketIOClient(
      socketURL: NSURL(string: App.serverURL) ?? NSURL(),
      options: [
        .ConnectParams(connectParams ?? [
          "room": UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        ] as [String: AnyObject]),
        .Log(false),
        .ForcePolling(true),
        .Cookies([
          NSHTTPCookie(properties: [
            NSHTTPCookieDomain: UIDevice.currentDevice().identifierForVendor!.UUIDString,
            NSHTTPCookiePath: "",
            NSHTTPCookieName: "client",
            NSHTTPCookieValue: UIDevice.currentDevice().identifierForVendor!.UUIDString,
            NSHTTPCookieSecure: true,
            NSHTTPCookieExpires: NSDate(timeIntervalSinceNow: 60)
          ])!]
        ),
        .Secure(false),
//        .Secure(App.isProduction)
      ]
    )
    
    return socket
  }
  
  public func disconnect(execute: (() -> Void)? = nil) {
    disconnectHandler = execute
    socket.removeAllHandlers()
    socket.disconnect()
  }
  
  public func onConnect(host: String, execute: () -> Void) {
    if connectExecutionArray != nil {
      connectExecutionArray?.updateValue(execute, forKey: host)
    } else {
      connectExecutionArray = [host: execute]
    }
  }
  
  public func onReconnectAttempt(host: String, execute: () -> Void) {
    if reconnectExecutionArray != nil {
      reconnectExecutionArray?.updateValue(execute, forKey: host)
    } else {
      reconnectExecutionArray = [host: execute]
    }
  }
  
  public func isConnected() -> Bool {
    return socket.status.rawValue == 3
  }
  
  public func off(event: String) {
    socket.off(event)
  }
  
  public func on(event: String, execute: (JSON -> Void)) {
    if isConnected() {
      socket.off(event)
      socket.on(event) { data, socket in
        if let json = JSON(data).array?.first { execute(json) }
      }
    } else {
      onConnect(event) { [weak self] in
        self?.socket.off(event)
        self?.socket.on(event) { data, socket in
          if let json = JSON(data).array?.first { execute(json) }
        }
      }
    }
  }
  
  public func emit(event: String, objects: [String: AnyObject], forceConnection: Bool = true) {
    if isConnected() {
      socket.emit(event, objects)
    } else if forceConnection {
      connect() { [weak self] in self?.socket.emit(event, objects) }
    }
  }
  
  public func emit(event: String, object: String, forceConnection: Bool = true) {
    if isConnected() {
      socket.emit(event, object)
    } else if forceConnection {
      connect() { [weak self] in self?.socket.emit(event, object) }
    }
  }
}

extension App {
  
  public static func onConnect(host: String, execute: () -> Void) {
    Socket.sharedInstance().onConnect(host, execute: execute)
  }
  
  public static func on(event: String, execute: SocketResponseBlock) {
    Socket.sharedInstance().on(event, execute: execute)
  }
  
  public static func emit(event: String, object: String) {
    Socket.sharedInstance().emit(event, object: object, forceConnection: true)
  }
  
  public static func emit(event: String, objects: [String: AnyObject]){
    Socket.sharedInstance().emit(event, objects: objects, forceConnection: true)
  }
}