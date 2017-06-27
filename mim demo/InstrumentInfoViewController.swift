//
//  InstrumentInfoViewController.swift
//  mim demo
//
//  Created by stephen eshelman on 6/25/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import UIKit

class InstrumentInfoViewController: UIViewController {
   
   var instrument:Instrument?
   {
      didSet{
      }
   }
   
   @IBAction func stopButtonClick(_ sender: Any) {
      instrument?.stop(callback: { (status) in
         print("info view start:\(status)")
         
         let alert =
            UIAlertController(
               title: "Alert",
               message: status,
               preferredStyle: UIAlertControllerStyle.alert)
         
         alert.addAction(UIAlertAction(title: "Ok", style: .default)
         { action in
         })
         
         self.navigationController?.present(alert, animated: true, completion:
         {
         })
      })
   }
   
   @IBAction func buttonClick(_ sender: Any) {
      instrument?.start(callback: { (status) in
         print("info view start:\(status)")
         
         let alert =
            UIAlertController(
               title: "Alert",
               message: status,
               preferredStyle: UIAlertControllerStyle.alert)
         
         alert.addAction(UIAlertAction(title: "Ok", style: .default)
         { action in
         })
 
         self.navigationController?.present(alert, animated: true, completion:
         {
         })

      })
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
