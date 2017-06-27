//
//  InstrumentViewController.swift
//  mim demo
//
//  Created by stephen eshelman on 6/25/17.
//  Copyright © 2017 stephen eshelman. All rights reserved.
//

import UIKit

class InstrumentViewController: UITableViewController {
   
   var instrument:Instrument?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return 2
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      
      // Configure the cell...
      switch indexPath.row {
      case 0:
         cell.textLabel?.text = "\(instrument?.name ?? "<unknown>") info"
         break
      case 1:
         cell.textLabel?.text = "Real Time Signals"
         break
      default:
         break
      }
      
      cell.selectionStyle = UITableViewCellSelectionStyle.blue
      cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      switch indexPath.row
      {
      case 0:
         let controller = storyboard.instantiateViewController(withIdentifier: "InstrumentInfoViewController")
         
         let instrumentInfoViewController = controller as! InstrumentInfoViewController
         
         instrumentInfoViewController.instrument = instrument

         navigationController?.pushViewController(controller, animated: true)
         break
      case 1:
         let controller = storyboard.instantiateViewController(withIdentifier: "SignalsTableViewController")
         
         let signalsTableViewController = controller as! SignalsTableViewController
         
         signalsTableViewController.instrument = instrument
         
         navigationController?.pushViewController(controller, animated: true)
         break
      default:
         break
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      print("about to segue")
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
