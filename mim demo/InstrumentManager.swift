//
//  InstrumentManager.swift
//  mim demo
//
//  Created by stephen eshelman on 6/12/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import CocoaAsyncSocket

protocol InstrumentManagerDelegate
{
   func instrumentListUpdate(instruments:[Instrument])
}

protocol InstrumentDelegate
{
   func notify(hint:String)
}

class Instrument
{
   var name:String?
   var serialnumber:String?
   
   var realtimeSignals:[[String:Any]]?
   
   var heartbeat:String? //instrument unique identifier
   {
      didSet{
         instrumentManager?.subscribe(subject: "\(heartbeat ?? "").realtimesignalsstatus", callback: { (payload) in
            //print(payload)
            do {
               
               self.realtimeSignals = try JSONSerialization.jsonObject(with: payload.data(using: .utf8)!) as? [[String:Any]]
               
               if self.delegate != nil
               {
                  self.delegate?.notify(hint: "realtimeSignals")
               }
               
            } catch let error as NSError {
               print(error)
            }
         })
      }
   }
   
   var location:String?
   {
      willSet
      {
         if location != nil
         {
            //send change to instrument
            print("   send change to instrument")
            
            instrumentManager?.set(heartbeat: heartbeat!, payload: location!)
         }
      }
      
   }
   
   var delegate:InstrumentDelegate?
   
   var instrumentType:String?
   
   var instrumentManager:InstrumentManager?
   
   init(instrumentManager:InstrumentManager)
   {
      self.instrumentManager = instrumentManager
   }
}

class InstrumentManager: NSObject, GCDAsyncSocketDelegate
{
   var _socket:GCDAsyncSocket?
   var _heartbeats:Dictionary<String, Instrument> = [:]
   var _requests:Dictionary<String, (String)->()> = [:] //[replyto : callback]
   var _subscriptions:Dictionary<String, (String)->()> = [:]

   var _msgIndex:Int = 10
   var _replytoIndex = 10
   
   var delegate:InstrumentManagerDelegate?
   
   //var dGroup:DispatchGroup
   
   var instruments:[Instrument]
   {
      get{return Array(_heartbeats.values)}
   }
   
   init(ip:String, port:Int)
   {
      //dGroup = DispatchGroup()
      
      super.init()
      
      _socket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
      
      
      do
      {
         try _socket?.connect(toHost: ip, onPort: UInt16(port))
      }
      catch
      {
         print(error.localizedDescription)
      }
   }
   
   //implement gets/sets/actions
   //heartbeat is instrument advertisement is instrument unique identifier
   func get(heartbeat:String, payload:String)
   {
   }
   
   func set(heartbeat:String, payload:String)
   {
      request(subject: "\(heartbeat).set.location", payload: payload)
      {status in
         print("location set was a: \(status)")
      }
   }
   
   func action(heartbeat:String, payload:String)
   {
   }
   /////////////////////////////
   
   func request(subject:String, payload:String, callback:@escaping (String)->())
   {
      _replytoIndex += 1
      _msgIndex += 1
      
      let replyto = "REPLYTO\(_replytoIndex)"
      
      //add to requests dictionary
      _requests[replyto] = callback
      
      let s = "SUB \(replyto) \(_msgIndex)\r\n"
      let p = "PUB \(subject) \(replyto) \(payload.lengthOfBytes(using: .utf8))\r\n\(payload)\r\n"
      
      _socket?.write(Data(bytes: Array(s.utf8)), withTimeout: -1, tag: 9)
      _socket?.write(Data(bytes: Array(p.utf8)), withTimeout: -1, tag: 9)
   }
   
   func subscribe(subject:String, callback:@escaping (String)->())
   {
      _msgIndex += 1
      
      let subscription = "SUB \(subject) \(_msgIndex)\r\n"
      
      _requests[subject] = callback
      
      _socket?.write(Data(bytes: Array(subscription.utf8)), withTimeout: -1, tag: 9)
   }
   
   func processReply(replyto:String, payload:String)
   {
      DispatchQueue.main.async {
         self._requests[replyto]!(payload)
      }
   }
   
   func processMSG(msg:String)
   {
      //look for subject
      //4 tokens ( no reply-to )
      //5 tokens ( reply-to is present )
      var tokens = msg._split(separator: " ")
      var lines:[String] = []
      
      let subject = tokens[1]
      
      msg.enumerateLines{
         line, _ in
         lines.append(line)
      }
      
      let payload = lines[1]
      
      if(subject == "heartbeat")
      {
         //get heartbeat
         
         let heartbeatExists = _heartbeats[payload] != nil
         
         if(!heartbeatExists)
         {
            _heartbeats[payload] = Instrument(instrumentManager: self)
            _heartbeats[payload]?.heartbeat = payload
            
            //print(payload)
            
            _msgIndex += 1
            
            //subscribe to something
            let error_sub = "SUB " + payload + ".error \(_msgIndex)\r\n"
            
            _socket?.write(Data(bytes: Array(error_sub.utf8)), withTimeout: -1, tag: 9)
            
            let dGroup = DispatchGroup()
            
            dGroup.enter()
            //request name
            request(subject: "\(payload).get", payload: "name")
            {name in
               if(self._heartbeats[payload]?.name) == nil
               {
                  print("\(payload):name:\(name)")
                  
                  self._heartbeats[payload]?.name = name
                  
                  dGroup.leave()
               }
            }
            
            dGroup.enter()
            //request serialnumber
            request(subject: "\(payload).get", payload: "serial number")
            {serialnumber in
               
               if (self._heartbeats[payload]?.serialnumber) == nil
               {
                  print("\(payload):serial number:\(serialnumber)")

                  self._heartbeats[payload]?.serialnumber = serialnumber
                  
                  dGroup.leave()
               }
            }
            
            dGroup.enter()
            //request location
            request(subject: "\(payload).get", payload: "location")
            {location in
               
               if(self._heartbeats[payload]?.location)==nil
               {
                  print("\(payload):location:\(location)")
                  
                  self._heartbeats[payload]?.location = location
                  
                  dGroup.leave()
               }
            }
            
            dGroup.enter()
            //request instrument type
            request(subject: "\(payload).get", payload: "instrument type")
            {instrumentType in
               if(self._heartbeats[payload]?.instrumentType)==nil
               {
                  print("\(payload):instrument type:\(instrumentType)")
                  
                  self._heartbeats[payload]?.instrumentType = instrumentType
                  
                  dGroup.leave()
               }
            }
            
            //notify once we have all instrument info
            dGroup.notify(queue: .main, execute: {
               
               print("  notifying \(payload)")
               
               self.delegate?.instrumentListUpdate(instruments: self.instruments)
               
            })
         }
      }
      
      if(subject.hasSuffix(".error"))
      {
         print(payload)
      }
      
      //another way to determine that
      if(_requests.keys.contains(subject))
      {
         processReply(replyto: subject, payload: payload)
      }
   }
   
   func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16)
   {
      print("connected: \(host)")
      
      let end = "\r\n"

      let heartbeat_sub = "SUB heartbeat 1\r\n"
      
      _socket?.readData(to: Data(bytes: Array(end.utf8)), withTimeout: -1, tag: 8)

      _socket?.write(Data(bytes: Array(heartbeat_sub.utf8)), withTimeout: -1, tag: 9)
   }
   
   var _message:String = ""
   
   func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int)
   {
      let s = String(data: data, encoding: .utf8)
      let pong = "PONG\r\n"
      
      //print("received data: \(String(describing: s))")
      
      let end = "\r\n"
      
      if (s?.hasPrefix("PING"))!
      {
         _socket?.write(Data(bytes: Array(pong.utf8)), withTimeout: -1, tag: 9)
      }
      
      //NEED TO PROCESS WHOLE MESSAGES
      
      
      if(s?.hasPrefix("MSG"))!
      {
         _message = s!
      }else if _message.hasPrefix("MSG")
      {
         _message += s!
         processMSG(msg: _message)
      }
      
      _socket?.readData(to: Data(bytes: Array(end.utf8)), withTimeout: -1, tag: 8)
   }
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      _socket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
      
      do
      {
         try _socket?.connect(toHost: "52.203.231.127", onPort: 4222)
      }
      catch
      {
         print(error.localizedDescription)
      }
      
      
      return true
   }
}

