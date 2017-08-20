//
//  AppDelegate.swift
//  mim demo
//
//  Created by stephen eshelman on 4/22/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import Feathers
import FeathersSwiftRest

extension String: ParameterEncoding {
   
   public func encode(
      _ urlRequest: URLRequestConvertible,
      with parameters: Parameters?)throws -> URLRequest
   {
      var request = try urlRequest.asURLRequest()
      request.httpBody = data(using: .utf8, allowLossyConversion: false)
      return request
   }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, InstrumentManagerDelegate
{
   
   var window: UIWindow?
   
   var _instrumentManager:InstrumentManager?
   
   func instrumentListUpdate(instruments: [Instrument])
   {
      for instrument in instruments
      {
         print("  client:\(instrument.name ?? "unknown")")
         
         if instrument.name == "Dio"
         {
            print("   GOT DIO!")
            //instrument.location = "SOMEWHERE ELSE!"
         }
      }
   }
   
   
   // Push notification received
   func application(
      _ application: UIApplication,
      didReceiveRemoteNotification data: [AnyHashable : Any])
   {
      // Print notification payload data
      print("Push notification received: \(data)")
   }
   
   // Called when APNs has assigned the device a unique token
   func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
   {
      // Convert token to string
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      
      // Print it to console
      print("APNs device token: \(deviceTokenString)")
      
      // Persist it in your backend in case it's new
      
      //send device token to our feathers service
      //      Alamofire.request(
      //         "http://10.52.50.83:3030/deviceTokens",
      //         method: .post,
      //         parameters: [:],
      //         encoding: "deviceid=\(deviceTokenString)",
      //         headers: [:]).responseJSON
      //         {
      //            (response) in
      //            print(response)
      //         }
      
      let feathersRestApp =
         Feathers(provider: RestProvider(baseURL: URL(string:"")!))
            
      Alamofire.request(
         "http://34.232.120.31:3030/deviceTokens",
         method: .post,
         parameters: ["deviceToken":deviceTokenString],
         encoding: JSONEncoding.default).responseJSON
         {
            (response) in
            
            print("DEVICE TOKENS")
            print(response)
         }
      
      
      let parameters: Parameters = ["deviceToken":"A0D05233EC3EA45AB1508545341CCB0DB365CE7A3804280BB87F0A6DF29DC292"]
      
      Alamofire.request(
         "http://10.52.50.83:3030/userSettings/",
         method: .get,
         parameters: parameters,
         encoding: URLEncoding()
         ).responseJSON
         { response in
            //print(response.request)  // original URL request
            //print(response.response) // HTTP URL response
            //print(response.data)     // server data
            //print(response.result)   // result of response serialization
            
            print("USER SETTINGS")
            if let JSON = response.result.value {
               print("JSON: \(JSON)")
            }
      }
      
      //      let dict = ["deviceid":deviceTokenString] as [String: Any]
      //      if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
      //      {
      //         let url = NSURL(string: "http://10.52.50.83:3030/deviceTokens")!
      //         let request = NSMutableURLRequest(url: url as URL)
      //         request.httpMethod = "POST"
      //
      //         request.httpBody = jsonData
      //         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      //
      //         let task = URLSession.shared.dataTask(with: request as URLRequest)
      //         {
      //            data,response,error in
      //            if error != nil
      //            {
      //               print("ERROR")
      //               return
      //            }
      //
      //            do
      //            {
      //               let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
      //
      //               if let parseJSON = json
      //               {
      //                  //let resultValue:String = parseJSON["success"] as! String;
      //                  //print("result: \(resultValue)")
      //                  print(parseJSON)
      //               }
      //            }
      //            catch let error as NSError
      //            {
      //               print(error)
      //            }
      //         }
      //         task.resume()
      //      }
      
   }
   
   // Called when APNs failed to register the device for push notifications
   func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error)
   {
      // Print the error to console (you should alert the user that registration failed)
      print("APNs registration failed: \(error)")
   }
   
   func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
   {
      // Override point for customization after application launch.
      
      //_instrumentManager = InstrumentManager(ip: "52.203.231.127", port: 4222)
      //_instrumentManager?.delegate = self
      
      // iOS 10 support
      if #available(iOS 10, *)
      {
         UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound])
         {
            (granted, error) in
            
            print(error ?? "no error!")
            print(granted)
         }
         
         application.registerForRemoteNotifications()
      }
         // iOS 9 support
      else if #available(iOS 9, *)
      {
         UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
         UIApplication.shared.registerForRemoteNotifications()
      }
         // iOS 8 support
      else if #available(iOS 8, *)
      {
         UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
         UIApplication.shared.registerForRemoteNotifications()
      }
         // iOS 7 support
      else
      {
         application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
      }
      
      return true
   }
   
   func applicationWillResignActive(_ application: UIApplication)
   {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
      
      print("applicationWillResignActive")
   }
   
   func applicationDidEnterBackground(_ application: UIApplication)
   {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      
      print("applicationDidEnterBackground")
   }
   
   func applicationWillEnterForeground(_ application: UIApplication)
   {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      
      print("applicationWillEnterForeground")
   }
   
   func applicationDidBecomeActive(_ application: UIApplication)
   {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
      print("applicationDidBecomeActive")
   }
   
   func applicationWillTerminate(_ application: UIApplication)
   {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      
      print("applicationWillTerminate")
   }
}

