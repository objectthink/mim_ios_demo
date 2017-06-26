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
}

class InstrumentCollectionViewController: UICollectionViewController, InstrumentManagerDelegate {
   
   var app:AppDelegate?
   var instrumentManager:InstrumentManager?
   var row:Int? = 0
   
   func instrumentListUpdate(instruments: [Instrument]) {
      collectionView?.reloadData()
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
      
      instrumentManager = app?._instrumentManager!;
      instrumentManager?.delegate = self
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
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InstrumentCollectionViewCell
      
      // Configure the cell
      cell.label.text = instrumentManager?.instruments[indexPath.row].name
      
      let instrument = instrumentManager?.instruments[indexPath.row]
      
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
