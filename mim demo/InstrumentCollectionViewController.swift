//
//  InstrumentCollectionViewController.swift
//  mim demo
//
//  Created by stephen eshelman on 6/25/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class InstrumentCollectionViewCell: UICollectionViewCell
{
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var statusLabel: UILabel!
}

class InstrumentCollectionViewController: UICollectionViewController, InstrumentManagerDelegate, InstrumentDelegate{
   
   var app:AppDelegate?
   var instrumentManager:InstrumentManager?
   var row:Int? = 0
   var cells = [String: InstrumentCollectionViewCell]()
   
   func instrumentListUpdate(instruments: [Instrument]) {
      collectionView?.reloadData()
   }
   
   func notify(subject:Instrument, hint:String)
   {
      if hint == "runstate"
      {
         //find instrument in instruments and get index
         //use index to get cell
         //change label background color based on instrument run state
         
         let cell = cells[subject.heartbeat!]
         
         if subject.runstate == "Idle"
         {
            cell?.statusLabel.backgroundColor = UIColor.green
         }
         else
         {
            cell?.statusLabel.backgroundColor = UIColor.red
         }
         
         cell?.statusLabel.text = subject.runstate
         
         //collectionView?.reloadData()
         
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Register cell classes
      //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
      
      // Do any additional setup after loading the view.
      
      self.collectionView?.delegate = self
      
      app = UIApplication.shared.delegate as? AppDelegate;
      
      //instrumentManager = InstrumentManager(ip: "34.232.120.31", port: 4222)
      instrumentManager = InstrumentManager(ip: "www.taclouddemo.com", port: 4222)
      instrumentManager?.delegate = self
   }
   
   override func viewWillAppear(_ animated: Bool) {
      //for instrument in (instrumentManager?.instruments)!
      //{
      //   instrument.delegate = self
      //}
      collectionView?.reloadData()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
   
   // MARK: UICollectionViewDataSource
   
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of items
      return (instrumentManager?.instruments.count)!
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
   {
      let cell = collectionView.dequeueReusableCell(
         withReuseIdentifier: reuseIdentifier,
         for: indexPath) as! InstrumentCollectionViewCell
      
      // Configure the cell
      let instrument = instrumentManager?.instruments[indexPath.row]
      
      instrument?.delegate = self
      
      cells[(instrument?.heartbeat)!] = cell

      cell.statusLabel.text = instrument?.runstate

      if instrument?.runstate == "Idle"
      {
         cell.statusLabel.backgroundColor = UIColor.green
      }
      else
      {
         cell.statusLabel.backgroundColor = UIColor.red
      }
      
      cell.label.text = instrument?.name
      
      if instrument?.instrumentType == "DSC"
      {
         cell.imageView.image = UIImage(named: "dsc")
      }
      
      if instrument?.instrumentType == "SDT"
      {
         cell.imageView.image = UIImage(named: "sdt")
      }
      
      if instrument?.instrumentType == "TGA"
      {
         cell.imageView.image = UIImage(named: "tga")
      }
      
      if instrument?.instrumentType == "NANO"
      {
         cell.imageView.image = UIImage(named: "nano")
      }

      //cell.imageView.adjustsImageWhenAncestorFocused = true
      
      return cell
   }
   
      //row = indexPath.row
   

   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
      row = indexPath.row
      return true
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      print("segue: \(segue.identifier ?? "")  \(segue.destination)")
      
      let vc = segue.destination as! InstrumentViewController
      
      vc.instrument = instrumentManager?.instruments[row!]
      
   }
   

   // MARK: UICollectionViewDelegate
   
   /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
   
}
