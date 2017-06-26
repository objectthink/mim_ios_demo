//
//  SignalsTableViewController.swift
//  mim demo
//
//  Created by stephen eshelman on 6/25/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import UIKit

class SignalsTableViewController: UITableViewController, InstrumentDelegate {
   
   var instrument:Instrument?
   {
      didSet{
         instrument?.delegate = self
      }
   }
   
   var signals:[[String:Any]]?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "signalCell")
      //tableView.dataSource = self
      //tableView.delegate = self
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   var i:Int = 0
   func notify(hint:String)
   {
      i += 1
      
      if i % 2 == 0
      {
         signals = instrument?.realtimeSignals
         //tableView.reloadData()
         
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      if signals != nil
      {
         return 1
      }
      return 0
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return (signals?.count)!
   }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "signalCell", for: indexPath)
    
    // Configure the cell...
    cell.textLabel?.text = signals?[indexPath.row]["_name"] as? String
    cell.detailTextLabel?.text = "\(signals?[indexPath.row]["_value"] ?? "<unkown>")"
    //cell.textLabel?.text = "\(signals?[indexPath.row]["_value"] ?? "<unkown>")"
      
    return cell
    }
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
